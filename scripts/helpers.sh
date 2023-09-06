# Set up klaxon-* aliases to automate common developer docker commands

# Start the app service in a new container. This is mostly just meant to be used
# by other aliases in this script.
alias klaxon-app="docker-compose run --rm app"

# Shorter way to run the Ruby rails command.
alias klaxon-rails="klaxon-app rails"

# Shorter way to run the Ruby rake command.
alias klaxon-rake="klaxon-app rake"

# Run tests
alias klaxon-test="klaxon-app bundle exec rspec"

# Get the container id of the running postgres container
# Note: This assumes you have exactly one container running with a database
alias klaxon-psql-container="docker-compose ps -q db"

# Run a command on the running postgres container
alias klaxon-psql-run="docker exec -tiu postgres \$(klaxon-psql-container)"

# Drop into a psql shell on the running postgres container
alias klaxon-psql="klaxon-psql-run psql"

# Run database migrations
alias klaxon-migrate="klaxon-rails db:migrate"

# Create admin records for each email in the ADMIN_EMAILS env variable
alias klaxon-create-admin="klaxon-rails users:create_admin"

# Check all watched pages
alias klaxon-check-all="klaxon-rake check:all"

# Drop and re-create the DB, not just flushing data from tables
klaxon-reset-db(){
    klaxon-psql-run sh -c "echo \"SELECT pg_terminate_backend(pg_stat_activity.pid) \
        FROM pg_stat_activity \
        WHERE pg_stat_activity.datname = 'klaxon'; \
        DROP database klaxon; \
        CREATE DATABASE klaxon;\" | psql"
}

# Automates several steps we may want to run whenever we switch branches
# 1. flush the database, deleting all of its contents
# 2. make the migrations
alias klaxon-bootstrap="klaxon-reset-db && klaxon-migrate"

# Help message for these commands. Excludes some that are meant to be used
# only internally by this script
alias klaxon-help="echo
echo \"klaxon dev commands\"
echo \"======================\"
echo
echo \"klaxon-bootstrap         - drop database, run migrations and import data\"
echo \"                              note: might be handy when switching branches\"
echo \"klaxon-check-all          - check all pages we are currently watching\"
echo \"klaxon-create-admin      - add users for each comma-separated email in ADMIN_EMAILS\"
echo \"klaxon-migrate          - run data migrations\"
echo \"klaxon-psql              - drop into a psql shell\"
echo \"klaxon-psql-container   - get the container ID of the postgres service\"
echo \"klaxon-psql-run          - run a command on the running postgres container\"
echo \"klaxon-reset-db        - drop the database and create a new empty one\"
echo \"klaxon-rails            - shortcut to run manage.py\"
echo \"                              example: klaxon-rails db:migrate\"
"