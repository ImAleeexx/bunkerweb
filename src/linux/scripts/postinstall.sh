#!/bin/bash

# Function to run a command and check its return code
function do_and_check_cmd() {
    output=$("$@" 2>&1)
    ret="$?"
    if [ $ret -ne 0 ] ; then
        echo "❌ Error from command : $*"
        echo "$output"
        exit $ret
    else
        echo "✔️ Success: $*"
        echo "$output"
    fi
    return 0
}

echo "Decompressing BunkerWeb dependencies..."
rm -rf /usr/share/bunkerweb/deps >/dev/null 2>&1
do_and_check_cmd tar -xzf /var/tmp/bunkerweb/deps.tar.gz -C /usr/share/bunkerweb
rm -f /var/tmp/bunkerweb/deps.tar.gz >/dev/null 2>&1

# Give all the permissions to the nginx user
echo "Setting ownership for all necessary directories to nginx user and group..."
do_and_check_cmd chown -R nginx:nginx /usr/share/bunkerweb /var/cache/bunkerweb /var/lib/bunkerweb /etc/bunkerweb /var/tmp/bunkerweb /var/run/bunkerweb /var/log/bunkerweb

# Copy old line from environment file to new one
# Check if old environment file exists
if [ -f /var/tmp/variables.env ]; then
    echo "Old environment file found!"
    echo "Copying old line from environment file to new one..."
    while read -r line; do
        echo "$line" >> /etc/bunkerweb/variables.env
    done < /var/tmp/variables.env
    # Remove old environment files
    echo "Removing old environment files..."
    do_and_check_cmd rm -f /var/tmp/variables.env
    do_and_check_cmd chown root:nginx /etc/bunkerweb/variables.env
    do_and_check_cmd chmod 660 /etc/bunkerweb/variables.env
else
    echo "Old environment file not found. Skipping copy..."
fi

# Copy old line from ui environment file to new one
# Check if old environment file exists
if [ -f /var/tmp/ui.env ]; then
    echo "Old ui environment file found!"
    touch /var/tmp/bunkerweb_upgrade
    echo "Copying old line from ui environment file to new one..."
    while read -r line; do
        echo "$line" >> /etc/bunkerweb/ui.env
    done < /var/tmp/ui.env
    # Remove old environment files
    echo "Removing old environment files..."
    do_and_check_cmd rm -f /var/tmp/ui.env
    do_and_check_cmd chown root:nginx /etc/bunkerweb/ui.env
    do_and_check_cmd chmod 660 /etc/bunkerweb/ui.env
else
    echo "Old ui environment file not found. Skipping copy..."
fi

# Check if old db.sqlite3 file exists
if [ -f /var/tmp/db.sqlite3 ]; then
    echo "Old db.sqlite3 file found!"
    touch /var/tmp/bunkerweb_upgrade
    do_and_check_cmd cp /var/tmp/db.sqlite3 /var/lib/bunkerweb/db.sqlite3
    # Remove old db.sqlite3 file
    echo "Copying old db.sqlite3 file to new one..."
    do_and_check_cmd rm -f /var/tmp/db.sqlite3
    do_and_check_cmd chown root:nginx /var/lib/bunkerweb/db.sqlite3
    do_and_check_cmd chmod 660 /var/lib/bunkerweb/db.sqlite3
else
    echo "Old database file not found. Skipping copy..."
fi

# Create /var/www/html if needed
if [ ! -d /var/www/html ] ; then
    echo "Creating /var/www/html directory ..."
    do_and_check_cmd mkdir -p /var/www/html
    do_and_check_cmd chmod 750 /var/www/html
    do_and_check_cmd chown root:nginx /var/www/html
else
    echo "/var/www/html directory already exists, skipping copy..."
fi

# Create bunkerweb if needed
if [ "$SERVICE_BUNKERWEB" != "no" ] ; then
    if [ -f /var/tmp/bunkerweb_upgrade ]; then
        # Reload bunkerweb service
        echo "Reloading bunkerweb service..."
        do_and_check_cmd systemctl reload bunkerweb
    else
        # Stop and disable nginx on boot
        echo "Stop and disable nginx on boot..."
        do_and_check_cmd systemctl stop nginx
        do_and_check_cmd systemctl disable nginx

        # Auto start BW service on boot and start it now
        echo "Enabling and starting bunkerweb service..."
        do_and_check_cmd systemctl enable bunkerweb
        do_and_check_cmd systemctl start bunkerweb
    fi
fi

# Create scheduler if necessary
if [ "$SERVICE_SCHEDULER" != "no" ] ; then
    if [ -f /var/tmp/bunkerweb_upgrade ] && systemctl is-active --quiet bunkerweb-scheduler; then
        # Reload bunkerweb-scheduler service
        echo "Reloading bunkerweb-scheduler service..."
        do_and_check_cmd systemctl restart bunkerweb-scheduler
    else
        # Auto start BW Scheduler service on boot and start it now
        echo "Enabling and starting bunkerweb service..."
        do_and_check_cmd systemctl enable bunkerweb-scheduler
        do_and_check_cmd systemctl start bunkerweb-scheduler
    fi

    if [ -f /var/tmp/bunkerweb_upgrade ]; then
        # Reload bunkerweb-ui service if running
        if systemctl is-active --quiet bunkerweb-ui; then
            echo "Reloading bunkerweb-ui service..."
            do_and_check_cmd systemctl restart bunkerweb-ui
        fi
    elif [ "$UI_WIZARD" != "no" ] ; then
        touch /etc/bunkerweb/ui.env
        do_and_check_cmd chown root:nginx /etc/bunkerweb/ui.env
        do_and_check_cmd chmod 660 /etc/bunkerweb/ui.env
        do_and_check_cmd systemctl enable bunkerweb-ui
        do_and_check_cmd systemctl start bunkerweb-ui
        echo "🧙 The setup wizard has been activated automatically."
        echo "Please complete the initial configuration at: https://your-ip-address-or-fqdn/setup"
        echo ""
        echo "Note: Make sure that your firewall settings allow access to this URL."
        echo ""
    fi
fi

if [ -f /var/tmp/bunkerweb_upgrade ]; then
    rm -f /var/tmp/bunkerweb_upgrade
    echo "BunkerWeb has been successfully upgraded! 🎉"
else
    echo "BunkerWeb has been successfully installed! 🎉"
fi

echo ""
echo "For more information on BunkerWeb, visit:"
echo "  * Official website: https://www.bunkerweb.io"
echo "  * Documentation: https://docs.bunkerweb.io"
echo "  * Community Support: https://discord.bunkerity.com"
echo "  * Commercial Support: https://panel.bunkerweb.io/order/support"
echo "🛡 Thank you for using BunkerWeb!"
