FROM ruby:2.7.6

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# set up the app directory
WORKDIR /usr/src/app

# copy over the dependency files
COPY Gemfile* .

# install dependencies
RUN bundle install

# copy over the rest of the app
COPY . .

# set default production environments
ENV RACK_ENV "production"
ENV RAILS_ENV "production"

# expose the port
EXPOSE 3000

# start the app
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
