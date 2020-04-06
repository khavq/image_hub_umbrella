#!/bin/sh
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $DB_HOST -p 5432 -U $DB_USER
do
  echo "$(date) - waiting for database to start $DB_HOST $DB_USER $DB_PASSWORD"
  sleep 2
done

./prod/rel/image_hub/bin/image_hub eval ImageHub.Release.migrate

./prod/rel/image_hub/bin/image_hub start
