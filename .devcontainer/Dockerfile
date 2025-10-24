ARG RUBY_VERSION=2.7.6
ARG RUBYGEMS_UPDATE_VERSION=1.8.30
ARG BUNDLER_VERSION=1.7.15

FROM ruby:$RUBY_VERSION-slim
LABEL maintainer="k.j.wierenga@kerkdienstgemist.nl"

# Common dependencies
# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

# Configure bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Uncomment this line if you store Bundler settings in the project's root
# ENV BUNDLE_APP_CONFIG=.bundle

# Uncomment this line if you want to run binstubs without prefixing with `bin/` or `bundle exec`
# ENV PATH /app/bin:$PATH

# Upgrade RubyGems and install required Bundler version
# ARG BUNDLER_VERSION
# ARG RUBYGEMS_UPDATE_VERSION
# RUN gem uninstall bundler && \
#     gem update --system $RUBYGEMS_UPDATE_VERSION && \
#     gem install bundler:$BUNDLER_VERSION

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT commands.
ENV WORKDIR=/app
RUN mkdir -p $WORKDIR
WORKDIR $WORKDIR
