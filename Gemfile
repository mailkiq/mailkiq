source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5'
gem 'clearance'
gem 'fog-aws'
gem 'responders'
gem 'simple_form'
gem 'puma'

# DB
gem 'pg'

# Assets
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
  gem 'pry-byebug'
  gem 'rspec-rails'
end
