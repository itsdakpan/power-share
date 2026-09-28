#!/usr/bin/env bash
# Build steps for Render. Runs on every deploy.
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:prepare
bin/rails demo:seed_if_empty
