#! /bin/bash

export RAILS_ENV=test

set -e

echo 'Running Jasmine'
bundle exec rake jasmine:ci

echo 'Running rspec'
bundle exec rspec spec



