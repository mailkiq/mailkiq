source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'addressable', require: false
gem 'aws-sdk', '~> 2'
gem 'devise'
gem 'has_scope'
gem 'jsonapi-resources'
gem 'page_meta'
gem 'paypal-recurring'
gem 'puma'
gem 'rouge', require: false
gem 'sentry-raven'
gem 'simple_form'
gem 'strip_attributes'

# Job scheduling
gem 'concurrent-ruby'
gem 'que'
gem 'que-web'

# DB
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
  gem 'database_rewinder'
  gem 'fabrication'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'pry-remote'
  gem 'rspec-rails'
end
