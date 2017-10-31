FROM ruby:2.3.4

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

ENV RACK_ENV "production"
ENV RAILS_ENV "production"

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
