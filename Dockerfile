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

# DB migrations
# RUN bundle exec rake db:migrate
RUN bundle exec rake assets:clean assets:precompile

# Start server
ENV PORT 5000
EXPOSE 5000

CMD [ "bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "5000", "config.ru" ] 
