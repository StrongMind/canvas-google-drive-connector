FROM ruby:2.5.0

RUN apt-get update && \
    apt-get install -y net-tools

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME; exit 0
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
ENV PORT 80
EXPOSE 80

CMD [ "bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "80", "config.ru" ] 