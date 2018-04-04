FROM ruby:2.5.0

RUN apt-get update -qq \
    && apt-get install -y apt-transport-https --no-install-recommends apt-utils \
    && apt-get install -y build-essential libpq-dev nodejs --no-install-recommends apt-utils \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install --no-install-recommends yarn

## Create folder
RUN mkdir /myapp

## Set working dir
WORKDIR /myapp

## Copy gemfile
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

RUN yarn install

EXPOSE 3000

CMD bundle exec rails s -p 3000 -b 0.0.0.0