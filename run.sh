#!/bin/bash
bundle exec rake assets:clean assets:precompile
bundle exec rackup -o 0.0.0.0 -p 5000 config.ru
