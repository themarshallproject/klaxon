# Running Klaxon with Docker

## Developing Klaxon using Docker

This assumes you already have Docker installed on your system. If you haven't done that yet, visit https://docs.docker.com/get-docker/

1. Run the following commands:

```
mkdir .docker_data
docker compose -f docker-compose.yml -f docker-compose-dev.yml up
```

The first time you do this may take a while as Docker downloads files and builds the container.

2. In a browser, open http://localhost:3000
 
3. Enter 'admin@news.org' in the email field. It should redirect you to a page that says: "Email Sent".

4. In the console find where it says "Go to Dashboard ( ... )" and copy and paste the link into the browser.

5. You'll now be logged in. The page should say "Watch Your First Item".

## Deploying Klaxon using Docker

TK: explain deployment methods, including elaborating environment variables below.

### Expected environment variables

Klaxon needs certain environment variables to be able to run. For development (see above), these are defined in files in this repository, but for production, the environment variable values are often things which should not be in version control, so if you're deploying using Docker, you'll need to make sure these are set correctly.

One way to accomplish this in Docker is with an [env file](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables-e-env-env-file). Below is a template for setting one up.

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
