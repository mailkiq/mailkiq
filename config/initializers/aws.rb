require 'aws/rails/mailer'
require 'aws/sns/message'

ActionMailer::Base.add_delivery_method :ses, Aws::Rails::Mailer
