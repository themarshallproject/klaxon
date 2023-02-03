# Setting up Klaxon in Docker locally for development

These instructions assume you have Git, Homebrew, Postgres, Ruby, and Docker installed locally.

## Setting up the environment

Let's start by setting up our environment. If you haven't already, create a `.env.local` file and populate it by running:

```
cp .env.local.example .env.local
```

Fill in the appropriate environment variable values as needed.

## Spinning up Docker

Let's use our `docker-compose.yml` file to build our Docker image, create our empty Postgres database and spin up our app. Notice that `docker-compose.yml` references the `.env.local` file we created above. Run:
```
docker-compose up
open http://localhost:3001
```

You should see a `PendingMigrationError` in your browser. You can either click the `Run pending migrations` button below the error description, or run:
```
source scripts/helpers.sh
klaxon-migrate
```