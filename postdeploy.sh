#!/bin/bash
set -e

bundle exec rake db:migrate
bundle exec rake users:create_admin

echo "postdeploy.sh done"
