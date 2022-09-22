FROM ruby:3.1.2-slim

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y bash curl tzdata build-essential \
    software-properties-common npm && \
    cp /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" > /etc/timezone

RUN npm install npm@latest --global && \
    npm install n yarn && \
    n 16

ENV RAILS_ENV=production \
    APP_HOME=/opt/app \
    PORT=5000

WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock "$APP_HOME"/
RUN bundle config set frozen 'true' && \
    bundle install

COPY package.json yarn.lock "$APP_HOME"/
RUN yarn install --frozen-lockfile

COPY . "$APP_HOME"

ENV PATH="${APP_HOME}/bin:${PATH}"

RUN ASSET_PRECOMPILE=1 \
    RAILS_ENV=production \
    bundle exec rails assets:precompile --trace 

EXPOSE $PORT
    
CMD ["bundle", "exec", "rails", "server"]
