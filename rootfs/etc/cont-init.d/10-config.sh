#!/usr/bin/with-contenv bash

# run klaxon startup commands
cd /usr/src/app
bundle exec rake db:create db:migrate || true
bundle exec rake users:create_admin || true



# Setup cron to run klaxon every 15 mins.
mkdir -p /config

if [[ ! -f /config/klaxon-cron ]]; then

cat > /config/klaxon-cron <<DELIM
#!/usr/bin/with-contenv bash

echo "running klaxon check.."

cd /usr/src/app
bundle exec rake check:all
DELIM

chmod +x /config/klaxon-cron

fi

if [[ ! -f /config/klaxon-crontab ]]; then

echo "*/15 * * * * root /config/klaxon-cron > /proc/1/fd/1 2>&1" > /etc/cron.d/klaxon-crontab
ln -s /config/klaxon-crontab /etc/cron.d/klaxon-crontab

fi