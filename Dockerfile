FROM rails:4.2.0
RUN apt-get update -qq && apt-get install -y build-essential
RUN mkdir /workspace
WORKDIR /workspace
ADD . /workspace
ADD Gemfile /workspace/Gemfile
ADD Gemfile.lock /workspace/Gemfile.lock
RUN bundle install --jobs 4
