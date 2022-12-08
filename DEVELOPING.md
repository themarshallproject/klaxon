# Developing Klaxon Locally

If you're interested in [helping improve Klaxon by contributing code](CONTRIBUTING.md), this is a quick guide to how to get it running on your local machine for development.

First, we'll assume you already have git on your local machine, as well as a standard postgres installation (if you need a [quick way to get Postgres up and running, try this](https://postgresapp.com/)). So go to your terminal, navigate to whatever directory where you keep your projects and clone the Klaxon repo.

```
git clone git@github.com:themarshallproject/klaxon.git
```

After you've cloned it, `cd` into the Klaxon directory. If you're on a Mac, you'll need to already have [homebrew](https://brew.sh/) and [rbenv](https://github.com/rbenv/rbenv) (a program that manages versions of Ruby) installed. Then you'll want

These next commands will put the proper (albeit aged) version of Ruby that Klaxon requires on your machine and make it available in this repo's directory.

**Note**: In the next step, `rbenv install` gave me the following error: 
```
To follow progress, use 'tail -f /var/folders/lj/l8g0s8bn049cs4wwt8r6bq480000gp/T/ruby-build.20221206173623.94097.log' or pass --verbose
Downloading openssl-1.1.1s.tar.gz...
-> https://dqw8nmjcqpjn7.cloudfront.net/c5ac01e760ee6ff0dab61d6b2bbd30146724d063eb322180c6f18a6f74e4b6aa
Installing openssl-1.1.1s...

BUILD FAILED (macOS 12.6.1 using ruby-build 20221206)

Inspect or clean up the working tree at /var/folders/lj/l8g0s8bn049cs4wwt8r6bq480000gp/T/ruby-build.20221206173623.94097.4yTOu3
Results logged to /var/folders/lj/l8g0s8bn049cs4wwt8r6bq480000gp/T/ruby-build.20221206173623.94097.log

Last 10 log lines:
***   issue on GitHub <https://github.com/openssl/openssl/issues>  ***
***   and include the output from the following command:           ***
***                                                                ***
***       perl configdata.pm --dump                                ***
***                                                                ***
***   (If you are new to OpenSSL, you might want to consult the    ***
***   'Troubleshooting' section in the INSTALL file first)         ***
***                                                                ***
**********************************************************************
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
```
which I resolved by installing xcode: `xcode-select install`. Later, I realized homebrew was tryna let me know all along with:
```
Error: python@3.11: the bottle needs the Apple Command Line Tools to be installed.
  You can install them, if desired, with:
    xcode-select --install
```
**end note**

```
brew update && brew upgrade ruby-build
rbenv install
```
**Note**: got this warning with `rbenv install`:
```
WARNING: ruby-2.7.6 is nearing its end of life.
It only receives critical security updates, no bug fixes.
```
**end note**

Next, you'll need to have the proper versions of all of Klaxon's dependency libraries. Run these commands here.

**Note**: In the next step, `gem install bundler` gave me an error:
```
Fetching bundler-2.3.26.gem
ERROR:  While executing gem ... (Gem::FilePermissionError)
    You don't have write permissions for the /Library/Ruby/Gems/2.6.0 directory.
```
According to the [rbenv docs](https://github.com/rbenv/rbenv#installing-ruby-gems), it's because my Ruby version is still a global default, so I tried running `rbenv global 2.7.6` to match the Dockerfile ruby version.

That didn't work, so I added `export PATH="$HOME/.rbenv/bin:$PATH"` to my `.zshrc`, similarly to how [these instructions specify it be done with bash](https://hathaway.cc/2008/06/how-to-edit-your-path-environment-variables-on-mac/). Ran `source ~/.zshrc`, confirmed my PATH looked right with `echo $PATH` and re-ran the `global` step, but still didn't work.

Then, I tried the `--user-install` flag, per [this post](https://stackoverflow.com/questions/14607193/how-to-install-a-gem-or-update-rubygems-if-it-fails-with-a-permissions-error), so: `gem install bundler --user-install` which seemed to work but I got this warning:
```
WARNING:  You don't have /Users/alapatik/.gem/ruby/2.6.0/bin in your PATH,
          gem executables will not run.
```
so I added `export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"` to my `~/.zshrc`. Ran `source .zshrc`, confirmed my PATH looked right with `echo $PATH`. Re-ran `gem install bundler --user-install` and it appears things are working.

But then `bundle install` gave me this error: `Your Ruby version is 2.6.10, but your Gemfile specified 2.7.6`. I eventually found [this link](https://stackoverflow.com/questions/10940736/rbenv-not-changing-ruby-version/12150580#12150580) which suggested I needed even more additions to my PATH. In the end, all the additions looked like:
```
# rbenv addition for Klaxon setup
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.6.0/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"
```
**end note**


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

Now, you should be able to go to [localhost:5000](http://localhost:5000/) in your web browser and see Klaxon's welcome screen pop up. You'll want to manually add a webpage or two to watch at [watching/pages/new](http://localhost:5000/watching/pages/new). For development purposes, you'll probably want to pick a site that updates pretty regularly. We use [http://www.timeanddate.com/](http://www.timeanddate.com/).

To get Klaxon to check for updates on the pages you're watching, in another terminal window, run this rake command.

```
rake check:all
```

Now, when you go to the main Klaxon page, you should start to see changes in the Feed of the latest updates.

Go forth and add some features, and be sure to send us your [pull requests](/pulls) for features you think other Klaxon users might find handy.
