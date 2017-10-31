## Install Klaxon on Ubuntu 14.04 (with CapHub or capistrano)

First, ensure that you have the libpq-dev package, ruby 2.3.4 and the bundler gem installed:

 * sudo apt-get install libpq-dev

 * gem install bundler (required both locally and on remote server)

 * rvm install ruby-2.3.4 (This assumes you have installed RVM.)

## Deploy with capitrano or caphub.

Properly creating a capistrano deployment task is beyond the scope of these instructions. But additional information can be found below:

* https://github.com/capistrano/capistrano

* https://github.com/railsware/caphub

In our our own setup, we use caphub to deploy multiple applications from a single capistrano environment. The commands below are shown as an example of how we deploy the code to our server.

We deploy the code to the production environment.

* bundle exec cap klaxon:production deploy:setup
* bundle exec cap klaxon:production deploy

ON THE SERVER run the following commands:

* bundle exec rake db:create RAILS_ENV=production (This creates your database using the config/database.yml file. Only do this on initial deploy)

* bundle exec rake db:migrate RAILS_ENV=production

## Deploy and set up your vhosts
We use nginx and have built capistrano tasks to build, deploy and enable reverse-proxy vhosts on our servers. You can perform these steps manually on your server. But we've included the step in capistrano commands that we run from our local Macs.

* bundle exec cap klaxon:production web:deploy_vhosts
* bundle exec cap klaxon:production web:enable

For an example of what a properly configured nginx vhosts might look like, please see the file klaxon-gninx-vhost-example.txt.

## Set up default admin users

This step is important because without it, you'll be unable to login to your application. The list of emails are just a list of comma separated values.

After modifying the command below to use your own email addresses, please run (on the server):

* bundle exec rake users:create_admin RAILS_ENV=production ADMIN_EMAILS=FIRST_EMAIL@YOURDOMAIN.org,SECOND_EMAIL@YOURDOMAIN.org,THIRD_EMAIL@YOURDOMAIN.org
