source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'addressable', require: false
gem 'clearance'
gem 'dedent'
gem 'fog-aws'
gem 'has_scope'
gem 'kaminari'
gem 'page_meta'
gem 'paypal-recurring'
gem 'puma'
gem 'responders'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'simple_form'
gem 'sinatra', require: false

# DB
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
