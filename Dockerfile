FROM ruby:3.0.0

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
build-essential libpq-dev git-all default-libmysqlclient-dev

ENV INSTALL_PATH /desafio-ninja

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile ./

ENV BUNDLE_PATH /app-gems

COPY . .

COPY ./start.sh /
RUN chmod +x /start.sh