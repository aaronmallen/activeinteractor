ARG BUILD_FROM

FROM $BUILD_FROM
LABEL maintainer="hello@aaronmallen.me"

RUN ruby -v
RUN apt-get update

RUN mkdir -p /src
WORKDIR /src

COPY . ./
RUN gem install bundler
RUN bundle check || bundle install --jobs 20 --retry 5

ENTRYPOINT [ "bundle", "exec" ]
