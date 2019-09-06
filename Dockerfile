FROM ruby:2.5.0

ENV LC_ALL C.UTF-8

RUN mkdir -p /app/vendor
WORKDIR /app
ENV PATH /app/bin:$PATH

COPY Gemfile Gemfile.lock /app/
RUN bundle install --local -j $(nproc)

COPY . /app/

EXPOSE 80

CMD [ "bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "80", "config.ru" ]