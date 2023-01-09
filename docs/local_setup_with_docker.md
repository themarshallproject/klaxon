# Setting up Klaxon in Docker locally for development

These instructions assume you have Git, Homebrew, Postgres, Ruby, and Docker installed locally.

## Setting up the environment

Let's start by setting up our environment. If you haven't already, create a `.env` file and add the following (populating with your own preferences, where applicable):
```
HOST='localhost:3001'
PORT=3001

# Database settings
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=klaxon
POSTGRES_HOST=db

# App settings
RACK_ENV=development
RAILS_ENV=development
# postgres URI pattern is postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]
DATABASE_URL="postgres://postgres:postgres@db:5432/klaxon"
SECRET_KEY_BASE="secret_key_base"
ADMIN_EMAILS="admin@news.org"
LAUNCHY_DRY_RUN=true # stop letter_opener from attempting to open a browser
BROWSER=/dev/null
```

## Spinning up Docker

Let's use our `docker-compose.yml` file to build our Docker image, create our empty Postgres database and spin up our app. Run:
```
docker-compose up
open http://localhost:3001
```

You should see a `PendingMigrationError` in your browser. You can either click the `Run pending migrations` button below the error description, or run:
```
source scripts/helpers.sh
klaxon-migrate
```