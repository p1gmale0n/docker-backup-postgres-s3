#!/usr/bin/env bash
# vim: set noexpandtab ts=4 sw=4 nolist:
set -Eeo pipefail

if [ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
	POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
	POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
fi

if [ -z "${POSTGRES_PORT}" ]; then
	POSTGRES_PORT=5432
fi

# env vars needed for aws tools
export AZURE_STORAGE_ACCOUNT=${AZURE_STORAGE_ACCOUNT}
export AZURE_STORAGE_KEY=${AZURE_STORAGE_KEY}
export CONTAINER_NAME=${CONTAINER_NAME}

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz

echo "Uploading dump to daily/${POSTGRES_DATABASE}-`date +%Y%m%d-%H%M%S`.sql.gz"

az storage blob upload --container-name $CONTAINER_NAME --file dump.sql.gz --name "daily/${POSTGRES_DATABASE}-`date +%Y%m%d-%H%M%S`.sql.gz"

echo "SQL backup uploaded successfully"
