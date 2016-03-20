source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'addressable', require: false
gem 'auto_strip_attributes'
gem 'clearance'
gem 'dedent'
gem 'fog-aws'
gem 'has_scope'
gem 'jsonapi-resources'
gem 'page_meta'
gem 'paypal-recurring'
gem 'puma'
gem 'responders'
gem 'sentry-raven'
gem 'simple_form'

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
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'thin'
end

group :test do
  gem 'database_rewinder'
  gem 'fabrication'
  gem 'rspec-sidekiq'
  gem 'shoulda-matchers'
  gem 'vcr'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-remote'
  gem 'rspec-rails'
end
