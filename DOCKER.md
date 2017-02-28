# Running Klaxon with Docker

To install docker and docker-compose, simply: `brew cask install docker`. Once installed, you'll need to open and run the Docker app.

(I think you might be able to just run `docker-compose up` once you're in the directory and after you've set the proper environment variables.)

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
