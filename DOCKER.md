# Running Klaxon with Docker

## Development Quickstart

1. Run the following commands:

```
docker-compose up
open http://localhost:3000
```

2. Enter 'admin@news.org' in the email window. It should redirect you to a page that says: "Email Sent".

3. In the console find where it says "Go to Dashboard ( ... )" and copy and paste the link into the browser.

4. You'll now be logged in. The page should say "Watch Your First Item".

## Expected environmental variables

Klaxon needs certain environmental variables to be able to run. One way to accomplish this in Docker is with an [env file](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables-e-env-env-file). Below is a template for setting one up.

```sh
DATABASE_URL=
SECRET_KEY_BASE=
ADMIN_EMAILS=
SENDGRID_USERNAME=
SENDGRID_PASSWORD=
```

If you would like to use [Amazon SES](https://aws.amazon.com/ses/) instead to send emails, you'll need a different set of environmental variables.

```sh
DATABASE_URL=
SECRET_KEY_BASE=
ADMIN_EMAILS=
SMTP_PROVIDER=SES
SES_ADDRESS=
SES_USERNAME=
SES_PASSWORD=
SES_DOMAIN=
MAILER_FROM_ADDRESS=
```
