#!/bin/bash

. /usr/share/bunkerweb/helpers/utils.sh

# trap SIGTERM and SIGINT
function trap_exit() {
	log "ENTRYPOINT" "ℹ️ " "Catched stop operation"
	if [ -f "/var/run/bunkerweb/ui.pid" ] ; then
		log "ENTRYPOINT" "ℹ️ " "Stopping UI ..."
		kill -s TERM "$(cat /var/run/bunkerweb/ui.pid)"
	fi
}
trap "trap_exit" TERM INT QUIT

if [ -f /var/run/bunkerweb/ui.pid ] ; then
	rm -f /var/run/bunkerweb/ui.pid
fi

log "ENTRYPOINT" "ℹ️ " "Starting the UI v$(cat /usr/share/bunkerweb/VERSION) ..."

python3 /usr/share/bunkerweb/ui/ui.py > /dev/null

if [ $? -ne 0 ] ; then
  log "ENTRYPOINT" "❌ " "The admin password is not strong enough. It must contain at least 8 characters, including at least 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character (#@?!$%^&*-)."
  exit 1
fi

read HOST PORT NUXT_API_ADDR NUXT_API_TOKEN NUXT_ADMIN_USERNAME NUXT_ADMIN_PASSWORD < <(echo $(python3 /usr/share/bunkerweb/ui/ui.py | jq -r '.listen_addr, .listen_port, .api_addr, .api_token, .admin_username, .admin_password'))

# execute jobs
log "ENTRYPOINT" "ℹ️ " "Executing UI ..."
export HOST
export PORT
export NUXT_API_ADDR
export NUXT_API_TOKEN
export NUXT_ADMIN_USERNAME
export NUXT_ADMIN_PASSWORD

node nuxt/.output/server/index.mjs &
pid="$!"
wait "$pid"
while [ -f /var/run/bunkerweb/ui.pid ] ; do
    wait "$pid"
done

# TODO add ui.healthy file that will be removed when the UI is stopped
# if [ -f /var/tmp/bunkerweb/ui.healthy ] ; then
# 	rm /var/tmp/bunkerweb/ui.healthy
# fi
log "ENTRYPOINT" "ℹ️ " "UI stopped"
exit 0