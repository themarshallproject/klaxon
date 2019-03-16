#!/usr/bin/with-contenv bash

# run klaxon startup commands
cd /usr/src/app
bundle exec rake db:create db:migrate || true
bundle exec rake users:create_admin || true



# Setup cron to run klaxon every 15 mins.
mkdir -p /config

if [[ ! -f /config/cron-15min ]]; then

cat > /config/cron-15min <<DELIM
#!/bin/sh
cd /usr/src/app
bundle exec rake check:all
DELIM
chmod +x /config/cron-15min

fi
