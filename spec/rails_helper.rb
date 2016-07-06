if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_group 'Validators', 'app/validators'
    add_group 'Presenters', 'app/presenters'
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'aasm/rspec'
require 'capybara/rails'
require 'capybara/rspec'

Capybara.app_host = 'https://mailkiq-test.com'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.include AbstractController::Translation
  config.include ActiveSupport::Testing::TimeHelpers
end
