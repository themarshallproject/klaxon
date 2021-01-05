#!/usr/bin/with-contenv bash

mkdir -p /config

# set defaults
KLAXON_CREATE_DB=${KLAXON_CREATE_DB:-true}
KLAXON_MIGRATE_DB=${KLAXON_MIGRATE_DB:-true}
KLAXON_CREATE_ADMIN=${KLAXON_CREATE_ADMIN:-true}
KLAXON_CRON_ENABLED=${KLAXON_CRON_ENABLED:-true}

# customizable klaxon startup commands
cd /usr/src/app
if [[ "${KLAXON_CREATE_DB}" = "true" ]]; then
    bundle exec rake db:create || true
fi
if [[ "${KLAXON_MIGRATE_DB}" = "true" ]]; then
    bundle exec rake db:migrate || true
fi
if [[ "${KLAXON_CREATE_ADMIN}" = "true" ]]; then
    bundle exec rake users:create_admin || true
fi
if [[ "${KLAXON_CRON_ENABLED}" = "true" ]]; then
    rm -rf /etc/services.d/cron/down
else
    touch /etc/services.d/cron/down
fi


# Setup cron to run klaxon every 15 mins.
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