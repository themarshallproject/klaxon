FROM ruby:2.7.6 as base

WORKDIR /usr/src/app

ENTRYPOINT ["/init"]

RUN apt-get update && \
    apt-get install -y cron && \
    rm -rf /var/lib/apt/lists/*

# install s6overlay so that we can run cron inside this container as well.
RUN wget -qO- https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz | tar xz -C /

RUN gem install bundler:2.3.22 && \
    bundle config --global frozen 1

EXPOSE 3000

COPY rootfs/ /

FROM base as development

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install

FROM base as production

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle config set --without 'development test' && \
    bundle install

COPY . /usr/src/app
