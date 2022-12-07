FROM ruby:2.7.6

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Set up the app directory
WORKDIR /usr/src/app

# Copy over the dependency files
COPY Gemfile* .

# Configure bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Install dependencies
RUN bundle install

# Copy over the rest of the app
COPY . .

# Set default production variables
ENV RACK_ENV "production"
ENV RAILS_ENV "production"

# Expose the port
EXPOSE 3000

# Start the app
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
