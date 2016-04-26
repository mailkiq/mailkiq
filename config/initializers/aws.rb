require 'aws/rails/mailer'
require 'aws/sns/message'

ActionMailer::Base.add_delivery_method :ses, Aws::Rails::Mailer

# S3_BUCKET = Aws::S3::Resource.new(
  # access_key_id: Rails.application.secrets[:]
  # secret_access_key:
# )
