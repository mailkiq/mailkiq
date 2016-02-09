source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5.1'
gem 'addressable', require: false
gem 'clearance'
gem 'fog-aws'
gem 'kaminari'
gem 'page_meta'
gem 'puma'
gem 'responders'
gem 'safely_block', require: false
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'simple_form'
gem 'sinatra', require: false

# DB
gem 'pg'

# Assets
gem 'bootstrap-sass', '~> 3.3.6'
gem 'bourbon'
gem 'jquery-rails'
gem 'sass-rails'
gem 'sprockets-es6'
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
  gem 'shoulda-matchers'
  gem 'vcr'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'pry-remote'
  gem 'rspec-rails'
end
