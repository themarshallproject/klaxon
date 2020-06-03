# Developing Klaxon Locally #

If you're interested in [helping improve Klaxon by contributing code](CONTRIBUTING.md), this is a quick guide to how to get it running on your local machine for development.

First, we'll assume you already have git on your local machine, as well as a standard postgres installation (if you need a [quick way to get Postgres up and running, try this](https://postgresapp.com/)). So go to your terminal, navigate to whatever directory where you keep your projects and clone the Klaxon repo.

```
git clone git@github.com:themarshallproject/klaxon.git
```

After you've cloned it, `cd` into the Klaxon directory. If you're on a Mac, you'll need to already have [homebrew](https://brew.sh/) and [rbenv](https://github.com/rbenv/rbenv) (a program that manages versions of Ruby) installed. Then you'll want 

These next commands will put the proper (albeit aged) version of Ruby that Klaxon requires on your machine and make it available in this repo's directory.

```
brew update && brew upgrade ruby-build
rbenv install
``` 

Next, you'll need to have the proper versions of all of Klaxon's dependency libraries, as well as foreman, a process manager that allows you to run a local server for development. Run these commands here.

```
gem install bundler
bundle install
gem install foreman
```

In order to be allowed to login to Klaxon once it's running on your machine, it'll need to know that your email address is. Create a file named `.env` and paste in these two items: 

```
ADMIN_EMAILS="my_awesome_email@gmail.com"
HOST='localhost:5000'
```

Feel free to substitute in your email address. In development, Klaxon doesn't actually send emails locally, so a real address is not required.

Now that's set, you'll run a couple of commands for Rails to create Klaxon's database on your machine.

```
rake db:create
rake db:migrate
```

Now, you should be about ready to get started. This command in the top folder of the Klaxon repo will get your dev server rolling.

```
foreman start
```

Now, you should be able to go to [localhost:5000](http://localhost:5000/) in your web browser and see Klaxon's welcome screen pop up. You'll want to manually add a webpage or two to watch at [watching/pages/new](http://localhost:5000/watching/pages/new). For development purposes, you'll probably want to pick a site that updates pretty regularly. We use [http://www.timeanddate.com/](http://www.timeanddate.com/). 

To get Klaxon to check for updates on the pages you're watching, in another terminal window, run this rake command.

```
rake check:all
```

Now, when you go to the main Klaxon page, you should start to see changes in the Feed of the latest updates.

Go forth and add some features, and be sure to send us your [pull requests](/pulls) for features you think other Klaxon users might find handy.
