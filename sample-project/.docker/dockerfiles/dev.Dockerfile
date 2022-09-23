FROM ruby:3.1.2-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y bash curl tzdata build-essential \
    software-properties-common npm && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

RUN npm install npm@latest --global && \
    npm install n yarn --global && \
    n 16

ENV RAILS_ENV=development \
  NODE_ENV=development \
  APP_HOME=/opt/app \
  PORT=5000

WORKDIR $APP_HOME

# Ensure gems are owned by docker user
ARG BUNDLE_PATH=/gems
ENV BUNDLE_PATH=$BUNDLE_PATH \
    BUNDLE_APP_CONFIG=$BUNDLE_PATH

# Create docker user with variable ID for dev
RUN mkdir -p $APP_HOME /gems && \
    addgroup --gid 1000 docker && \
    adduser --uid 1000 --ingroup docker --home /home/docker --shell /bin/sh --disabled-password --gecos "" docker && \
    chown -R docker:docker $APP_HOME /gems

RUN USER=docker && \
    GROUP=docker && \
    curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.5.1/fixuid-0.5.1-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: $USER\ngroup: $GROUP\npaths:\n- /\n- /gems" > /etc/fixuid/config.yml

USER docker:docker

EXPOSE $PORT

ENTRYPOINT ["./.docker/scripts/entrypoint-dev"]

CMD ["./.docker/scripts/startup-app-dev"]
