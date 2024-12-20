#!/bin/bash

# shellcheck disable=SC1091
. /usr/share/bunkerweb/helpers/utils.sh

# trap SIGTERM and SIGINT
function trap_exit() {
	# shellcheck disable=SC2317
	log "ENTRYPOINT" "ℹ️ " "Caught stop operation"
	# shellcheck disable=SC2317
	if [ -f "/var/run/bunkerweb/scheduler.pid" ] ; then
		# shellcheck disable=SC2317
		log "ENTRYPOINT" "ℹ️ " "Stopping job scheduler ..."
		# shellcheck disable=SC2317
		kill -s TERM "$(cat /var/run/bunkerweb/scheduler.pid)"
	fi
}
trap "trap_exit" TERM INT QUIT

if [ -f /var/run/bunkerweb/scheduler.pid ] ; then
	rm -f /var/run/bunkerweb/scheduler.pid
fi

log "ENTRYPOINT" "ℹ️" "Starting the job scheduler v$(cat /usr/share/bunkerweb/VERSION) ..."

# setup and check /data folder
/usr/share/bunkerweb/helpers/data.sh "ENTRYPOINT"

if [[ $(echo "$SWARM_MODE" | awk '{print tolower($0)}') == "yes" ]] ; then
	echo "Swarm" > /usr/share/bunkerweb/INTEGRATION
elif [[ $(echo "$KUBERNETES_MODE" | awk '{print tolower($0)}') == "yes" ]] ; then
	echo "Kubernetes" > /usr/share/bunkerweb/INTEGRATION
elif [[ $(echo "$AUTOCONF_MODE" | awk '{print tolower($0)}') == "yes" ]] ; then
	echo "Autoconf" > /usr/share/bunkerweb/INTEGRATION
fi

# Database migration section
log "ENTRYPOINT" "ℹ️" "Checking database configuration..."
cd /usr/share/bunkerweb/db/alembic || {
	log "ENTRYPOINT" "❌" "Failed to access database migration directory"
	exit 1
}

# Extract and validate database type
DATABASE_URI=${DATABASE_URI:-sqlite:////var/lib/bunkerweb/db.sqlite3}
DATABASE=$(echo "$DATABASE_URI" | awk -F: '{print $1}' | awk -F+ '{print $1}')

# Validate database type with case-insensitive comparison
db_type=$(echo "$DATABASE" | tr '[:upper:]' '[:lower:]')
case "$db_type" in
	sqlite|mysql|mariadb|postgresql)
		log "ENTRYPOINT" "ℹ️" "Using database type: $DATABASE"
		;;
	*)
		log "ENTRYPOINT" "❌" "Unsupported database type: $DATABASE"
		exit 1
		;;
esac

# Update configuration files
if ! sed -i "s|^sqlalchemy\\.url =.*$|sqlalchemy.url = $DATABASE_URI|" alembic.ini; then
	log "ENTRYPOINT" "❌" "Failed to update database URL in configuration"
	exit 1
fi

if ! sed -i "s|^version_locations =.*$|version_locations = ${DATABASE}_versions|" alembic.ini; then
	log "ENTRYPOINT" "❌" "Failed to update version locations in configuration"
	exit 1
fi

# Check current version and stamp
log "ENTRYPOINT" "ℹ️" "Checking database version..."
installed_version=$(cat /usr/share/bunkerweb/VERSION)
current_version=$(python3 -c "
import sqlalchemy as sa
from os import getenv

from Database import Database
from logger import setup_logger

LOGGER = setup_logger('Scheduler', getenv('CUSTOM_LOG_LEVEL', getenv('LOG_LEVEL', 'INFO')))

engine = Database(LOGGER, '${DATABASE_URI}').sql_engine
with engine.connect() as conn:
	try:
		result = conn.execute(sa.text('SELECT version FROM bw_metadata WHERE id = 1'))
		print(next(result)[0])
	except BaseException as e:
		if 'doesn\'t exist' not in str(e):
			print('none')
		print('${installed_version}')
")

if [ "$current_version" == "none" ]; then
	log "ENTRYPOINT" "❌" "Failed to retrieve database version"
	exit 1
fi

if [ "$current_version" != "$installed_version" ]; then
	# Find the corresponding Alembic revision by scanning migration files
	MIGRATION_DIR="/usr/share/bunkerweb/db/alembic/${DATABASE}_versions"
	NORMALIZED_VERSION=$(echo "$current_version" | tr '.' '_' | tr '-' '_')
	REVISION=$(find "$MIGRATION_DIR" -maxdepth 1 -type f -name "*_upgrade_to_version_${NORMALIZED_VERSION}.py" -exec basename {} \; | awk -F_ '{print $1}')

	if [ -z "$REVISION" ]; then
		log "ENTRYPOINT" "❌" "No migration file found for database version: $current_version"
		exit 1
	fi

	# Stamp the database with the determined revision
	if ! python3 -m alembic stamp "$REVISION"; then
			log "ENTRYPOINT" "❌" "Failed to stamp database with revision: $REVISION"
			exit 1
	fi

	# Run database migration
	log "ENTRYPOINT" "ℹ️" "Running database migration..."
	if ! python3 -m alembic upgrade head; then
		log "ENTRYPOINT" "❌" "Database migration failed"
		exit 1
	fi

	log "ENTRYPOINT" "✅" "Database migration completed successfully"
fi

cd - > /dev/null || exit 1

# execute jobs
log "ENTRYPOINT" "ℹ️ " "Executing scheduler ..."
/usr/share/bunkerweb/scheduler/main.py &
pid="$!"

wait "$pid"
exit_code=$?

if [ -f /var/tmp/bunkerweb/scheduler.healthy ] ; then
	rm -f /var/tmp/bunkerweb/scheduler.healthy
fi

log "ENTRYPOINT" "ℹ️ " "Scheduler stopped"
exit $exit_code
