# Running Klaxon with Docker

*This guide is a work in progress.*

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
EMAIL_FROM_ADDRESS=
```
