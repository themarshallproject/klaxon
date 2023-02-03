# Connecting to a remote Klaxon database in an AWS Aurora cluster

This documentation is primarily for first-time setup to connect a locally running app to a remote Aurora cluster database. This is useful if you plan to deploy Klaxon to remote AWS resources and first want to establish that your app will have a working connection to its database. This doc assumes several things:
- The app is running locally in a Docker container
- You have already created an Aurora RDS cluster where the Klaxon database will be housed. That cluster should be configured in a way that is compatible with PostgreSQL 14. For our purposes at the Post, we used `database_engine_version: 14.4` and `instance_size: db.t4g.medium`. [Here is a guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html#Concepts.DBInstanceClass.Support) to help you select a compatible instance size. We deploy our AWS resources in infrastructure-specific repos, however resources [can also be created in the AWS console](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.CreateInstance.html).
- You have master credentials to access the Postgres database.

## Create the database and app user

First, we need to create a database called `klaxon` on the new cluster and add a user role that will be used by our app. You will need the master credentials mentioned above, as well as the endpoint for the cluster, which can be [found in the AWS console](https://docs.aws.amazon.com/documentdb/latest/developerguide/db-cluster-endpoints-find.html). Open a psql shell on the remote cluster like:
```
psql --host=<CLUSTER ENDPOINT> --username=<MASTER USERNAME> --password
```

This will prompt you for the master password. Then, you will be in the psql shell where you can run:
```
CREATE DATABASE klaxon;
CREATE ROLE <app username> WITH LOGIN PASSWORD '<password>';
GRANT ALL PRIVILEGES ON DATABASE klaxon TO <app username>;
```

Leave this shell open, we'll come back to it at the end!

## Create a new environment

Open a new terminal window for the following steps.

Unlike the test, development, production environments (for automated tests, local development, and live production, respectively), we at the Washington Post use local, dev, and prod. Regardless of what convention your team uses, we want to create an `.env` file that will contain the credentials for this remote db (and eventually, the remote app). Create that file with whatever name you choose. We use:
```
touch .env.dev
```

To populate the new `.env.dev` file, you'll need credentials for your database. You'll also need the [endpoint for the cluster's writer instance](https://docs.aws.amazon.com/images/AmazonRDS/latest/AuroraUserGuide/images/AuroraMySQLConnect.png) and the port (also available in the console, under `Connectivity & security`). Populate the new `.env.dev` file by running:

```
cp .env.dev.example .env.dev
```

Now, we need our Docker container to know which environment to reference. Go to your `docker-compose.yml` file and edit the `env_file` value for both your database and the app to reference your new `.env.dev` file. It should look something like:

```
volumes:
  postgres_data_local: {}
services:
  db:
    image: postgres:14
    env_file:
      - .env.dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data_local:/var/lib/postgresql/data

  app:
    ports: 
      - "3000:3000"
    env_file:
      - .env.dev
    build: .
    depends_on:
      - db
```

## Spin up the app

```
docker-compose up
```

Head to [localhost:3000](localhost:3000), and you should see a `PendingMigrationError` error. Click the `Run pending migrations` button below the error description, or run:
```
source scripts/helpers.sh
klaxon-migrate
```

## Confirm the remote database is populated with the Klaxon schema

Go back to the terminal window with the psql shell on the remote database. Enter the `klaxon` database and look at the tables available:
```
\c klaxon
\dt
```
If you see (as of the time of this writing) 10 relations, then yay! Your database is configured and ready to be used by the app!

## Sidenote on sharing the .env files with teammates

An easy way to share the template for these .env files it to also create an example file like:
```
touch .env.dev.example
```

Then, we can edit our .gitignore to look something like:
```
.env* # ignore all the real env files with secrets in them
!.env.*.example # but don't ignore the template
```

Then, as a bootstrapping step, folks can copy the contents of the example file into the real .env file before filling it out with all the :sparkles:secrets:sparkles: like:
```
cp .env.dev.example .env.dev
```