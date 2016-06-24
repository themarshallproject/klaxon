#!/bin/bash
set -e

echo "Creating backup ..."
heroku pg:backups capture --app klaxon-dev

echo " ----- "
echo "Downloading backup ..."
curl -o ./backups/dev-latest.dump `heroku pg:backups public-url --app klaxon-dev`

echo " ----- "
echo "Restoring backup to endrun_development"
/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_restore --verbose --clean --no-acl --no-owner -h localhost -U `whoami` -d klaxon_development ./backups/dev-latest.dump
