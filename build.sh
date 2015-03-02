#! /bin/bash

export RAILS_ENV=test

set -e

echo 'Running test setup'
bundle exec rake db:test:prepare

echo 'Running rspec'
bundle exec rspec spec



