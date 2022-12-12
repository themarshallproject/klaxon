# Developing Klaxon Locally

This guide is an adaptation of the original [Klaxon developing file](https://github.com/themarshallproject/klaxon/blob/develop/DEVELOPING.md) for use by the Washington Post News Engineering team.

We're assuming that git, homebrew, and [postgres](https://postgresapp.com/) are already installed on your machine.

Start by cloning our fork of the Klaxon repo:

```
git clone https://github.com/WPMedia/klaxon.git
```

Then, we'll need to install xcode:

```
xcode-select --install
```

Next, we'll install rbenv to manage our ruby environment:

```
brew install rbenv --auto-update
```

These next commands will put the proper (albeit aged) version of Ruby that Klaxon requires on your machine and make it available in this repo's directory.

```
brew update && brew upgrade ruby-build
rbenv install
```

Next, we'll want to make sure our ruby environment is properly initialized. Open your `~/.zshrc` (or `~/.bash` if that's your jam):

```
open ~/.zshrc
```

and add the following:

```
# rbenv addition for Klaxon setup
eval "$(rbenv init -)"
```

and then source your updated zsh (or bash) file:

```
source ~/.zshrc
```

Next, you'll need to have the proper versions of all of Klaxon's dependency libraries. Run these commands here.

```
gem install bundler
bundle install
```

In order to be allowed to login to Klaxon once it's running on your machine, it'll need to know that your email address is. Create a file named `.env` and paste in these two items:

```
ADMIN_EMAILS="my_awesome_email@gmail.com"
HOST='localhost:5000'
```

Feel free to substitute in your email address. In development, Klaxon doesn't actually send emails locally, so a real address is not required.

Now that's set, you'll run a couple of commands for Rails to create Klaxon's database on your machine.

```
bin/rake db:create
bin/rake db:migrate
```

Now, you should be about ready to get started. This command in the top folder of the Klaxon repo will get your dev server rolling.

```
bin/dev
```

If you get an error related to `puma`, try uninstalling and re-installing `foreman`:

```
gem uninstall foreman
gem install foreman
```

Now, you should be able to go to [localhost:5000](http://localhost:5000/) in your web browser and see Klaxon's welcome screen pop up. You'll want to manually add a webpage or two to watch at [watching/pages/new](http://localhost:5000/watching/pages/new). For development purposes, you'll probably want to pick a site that updates pretty regularly. We use [http://www.timeanddate.com/](http://www.timeanddate.com/).

To get Klaxon to check for updates on the pages you're watching, in another terminal window, run this rake command.

```
rake check:all
```

Now, when you go to the main Klaxon page, you should start to see changes in the Feed of the latest updates.

Go forth and add some features, and be sure to send us your [pull requests](/pulls) for features you think other Klaxon users might find handy.
