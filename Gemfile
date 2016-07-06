source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '5.0.0'
gem 'active_model_serializers'
gem 'addressable', require: false
gem 'appsignal'
gem 'aws-sdk', '~> 2'
gem 'devise'
gem 'email_validator', require: 'email_validator/strict'
gem 'has_scope'
gem 'iugu'
gem 'page_meta'
gem 'puma'
gem 'rouge', require: false
gem 'simple_form'
gem 'sinatra', github: 'sinatra/sinatra'
gem 'strip_attributes'

# Job scheduling
gem 'que'
gem 'que-web'

# DB
gem 'aasm'
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
  gem 'guard-migrate'
  gem 'guard-rspec'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'database_rewinder', '0.6.0'
  gem 'fabrication'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'pry-remote'
  gem 'rspec-rails'
end
