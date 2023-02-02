FROM public.ecr.aws/docker/library/ruby:2.7.6

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Install cron
RUN apt-get -y update && apt-get install -y cron
# Create the log file to be able to store logs
RUN touch /var/log/cron.log
# Cron (at least in Debian) does not execute crontabs with more than 1 hardlink, see bug 647193.
# As Docker uses overlays, it results with more than one link to the file, so you have to touch
# it in your startup script, so the link is severed.
RUN touch /etc/crontab /etc/cron.*/*


# Set up the app directory
WORKDIR /usr/src/app

# Configure bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Copy over the dependency files
COPY Gemfile .
COPY Gemfile.lock .

# Install dependencies
RUN bundle install

# Copy over the rest of the app
COPY . .

RUN ["chmod", "+x", "./docker-entrypoint.sh"]

EXPOSE 3001

ENTRYPOINT ["./docker-entrypoint.sh"]

# As written this first command will not execute since it's the first of two `CMD`s
CMD ["bundle", "exec", "rails", "assets:precompile"] 
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
