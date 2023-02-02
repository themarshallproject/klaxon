#!/bin/bash

# Add crontab jobs
echo "Calling script to set up server cronjobs"
/bin/bash scripts/cron_setup.sh

# Compile static assets before launching server
bundle exec rails assets:precompile

# Launch the main container command passed as arguments.
exec "$@"
