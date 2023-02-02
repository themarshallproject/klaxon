#!/bin/bash

# Pass environment variables to the crontab env.
# This is critical for the cron service to be able to execute bundle in the right
# configuration
env >> /etc/environment

# Add cron job to crontab
# cd into klaxon root dir and run rake command to check for website changes
(echo "*/10 * * * * /bin/bash -l -c 'cd /usr/src/app && bundle exec rake check:all' > /proc/1/fd/1 2>&1") | crontab
# We redirect the output of the cron job (> /proc/1/fd/1 2>&1) so that it will be
# included in standard error / out.
# For more context: https://gist.github.com/mowings/59790ae930accef486bfb9a417e9d446

echo "Starting cron ..."
# Run cron in the foreground, but make it not block subsequent processes
cron start