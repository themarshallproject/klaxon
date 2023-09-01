# Developing Klaxon Locally

If you're interested in [helping improve Klaxon by contributing code](CONTRIBUTING.md), this is a quick guide to how to get it running on your local machine for development.

First, we'll assume you already have git on your local machine, as well as PostgreSQL (if you need a [quick way to get Postgres up and running, try this](https://postgresapp.com/)). Go to your terminal, navigate to the directory where you keep projects and clone the Klaxon repository.

After you've cloned it move into the Klaxon directory. If you're on a Mac, you'll need to already have [homebrew](https://brew.sh/) and [rbenv](https://github.com/rbenv/rbenv) (a program that manages versions of Ruby) installed. Then you'll want

These next commands will install the version of Ruby that Klaxon requires on your machine and make it available in this directory.

```
brew update && brew upgrade ruby-build
rbenv install
```

Next, you'll need to have the proper versions of all of Klaxon's dependency libraries. Run these commands here.

```
gem install bundler
bundle install
```

In order to be allowed to login to Klaxon once it's running on your machine, it'll need to know that your email address is. Create an env file for local development like so:

```
cp .env.local.example .env.local
```

Feel free to substitute in your email address for the `ADMIN_EMAILS` value in the newly created `.env.local` file. In development, Klaxon doesn't actually send emails locally so a real address is not required. You just need to make sure you use exactly the same thing when you log in to the admin interface locally. With that set you'll run a couple of commands to create Klaxon's database on your machine.

```
bin/rake db:create
bin/rake db:migrate
```

You're about ready to get started. This command in the top folder of the Klaxon repo will start the development server.

```
bin/dev
```

Visit [localhost:5000](http://localhost:5000/) in your web browser and you should see Klaxon's welcome screen. Log in using the email you set above. Try to manually add a webpage or two at [watching/pages/new](http://localhost:5000/watching/pages/new). For development purposes you'll probably want to pick a site that updates pretty regularly — we use [http://www.timeanddate.com/](http://www.timeanddate.com/).

To get Klaxon to check for updates on the pages you're watching, in another terminal window run this command:

```
rake check:all
```

When you go to the main Klaxon page you should see new changes in the feed.

Go forth and add some new features!
