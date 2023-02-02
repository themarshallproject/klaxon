#!/bin/bash

# Add crontab jobs
echo "Calling script to set up server cronjobs"
/bin/bash scripts/cron_setup.sh

# Launch the main container command passed as arguments.
exec "$@"