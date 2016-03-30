source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'addressable', require: false
gem 'aws-sdk', '~> 2'
gem 'clearance'
gem 'dedent'
gem 'has_scope'
gem 'jsonapi-resources'
gem 'page_meta'
gem 'paypal-recurring'
gem 'puma'
gem 'redis-rails'
gem 'responders'
gem 'sentry-raven'
gem 'simple_form'
gem 'strip_attributes'

# Job scheduling
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'sidekiq-unique-jobs'
gem 'sinatra', require: false

# DB
gem 'groupdate'
gem 'kaminari'
gem 'pg'

# Assets
gem 'bourbon'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'sass-rails'
gem 'uglifier'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'faker', require: false
  gem 'guard-migrate'
  gem 'guard-rspec'
  gem 'meta_request'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'database_rewinder'
  gem 'fabrication'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-remote'
  gem 'rspec-rails'
end
