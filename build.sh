#! /bin/bash

export RAILS_ENV=test

set -e

echo 'Running test setup'
bundle exec rake rake db:test:prepare


echo 'Running Jasmine'
bundle exec rake jasmine:ci

echo 'Running rspec'
bundle exec rspec spec



