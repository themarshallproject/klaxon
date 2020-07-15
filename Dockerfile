FROM ruby:2.5.7

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

EXPOSE 3000

# install s6overlay so that we can run cron inside this container as well.
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.8.0/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    && mkdir /config \
    && apt-get update \
    && apt-get install -y cron \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs/ /
VOLUME ["/config"]

ENTRYPOINT ["/init"]
