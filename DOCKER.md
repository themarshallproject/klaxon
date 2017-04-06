# Running Klaxon with Docker

To install docker and docker-compose, simply: `brew cask install docker`. Once installed, you'll need to open and run the Docker app.

Next you'll need to edit the project's configuration.

* `touch .env`
* `atom .env`
* copy & paste from template below
* get SES env variables from [SES console page](https://console.aws.amazon.com/ses/home?region=us-west-2#)
  * get username & password from SMTP Settings > Create My SMTP Credentials
  * SES_DOMAIN = axios.com
  * MAILER_FROM_ADDRESS = klaxon@axios.com
  * SES_ADDRESS=email-smtp.us-west-2.amazonaws.com
  * ADMIN_EMAILS=gerald@axios.com,duner@axios.com
  * SECRET_KEY_BASE=ca5c95f210a558a20ef67c1959819a948f111a1a4cef334ae37dde40ae752023de4ba33f390782669330ae4bfc40db4e8e485f7e3e9ae17c708f7f4e1ae41f02
     * random?
     * necessary?



Finally, run

```
docker network create proxy // if running for the first time
docker-compose up
```
once you're in the directory to setup the rest.

You'll need to open a separate terminal tab and run:
```sh
docker exec klaxon bundle exec rake db:migrate
docker exec klaxon bundle exec rake users:create_admin
```
## Expected environmental variables

Klaxon needs certain environmental variables to be able to run. One way to accomplish this in Docker is with an [env file](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables-e-env-env-file). Below is a template for setting one up.

```sh
DATABASE_URL=
SECRET_KEY_BASE=
ADMIN_EMAILS=
SENDGRID_USERNAME=
SENDGRID_PASSWORD=
```

If you would like to use [Amazon SES](https://aws.amazon.com/ses/) instead to send emails, you'll need a different set of environmental variables. Note that your SES username and password are different from your AWS secret key pair. Don't put quotes around any of your environment variables or you will make Ruby angry.

```sh
DATABASE_URL=postgres://postgres:postgres@db:5432/postgres
SECRET_KEY_BASE=
ADMIN_EMAILS=
SMTP_PROVIDER=SES
SES_ADDRESS=
SES_SMTP_USERNAME=
SES_SMTP_PASSWORD=
SES_DOMAIN=
MAILER_FROM_ADDRESS=
```
