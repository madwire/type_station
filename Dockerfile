FROM ruby:2.3
ENV BUNDLE_PATH /bundler

RUN apt-get update -qq && apt-get install -y build-essential

RUN mkdir /workspace
WORKDIR /workspace

ADD . /workspace

RUN bundle install --jobs 4
ADD . /workspace
