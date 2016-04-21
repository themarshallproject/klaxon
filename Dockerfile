FROM ruby:2.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

ENV KUBERNETES_SECRET_ENV_VERSION=0.0.1
RUN \
mkdir -p /etc/secret-volume && \
cd /usr/local/bin && \
curl -sfLO https://github.com/newsdev/kubernetes-secret-env/releases/download/$KUBERNETES_SECRET_ENV_VERSION/kubernetes-secret-env && \
chmod +x kubernetes-secret-env

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

ENV RACK_ENV "production"
ENV RAILS_ENV "production"

EXPOSE 3000
ENTRYPOINT ["kubernetes-secret-env"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
