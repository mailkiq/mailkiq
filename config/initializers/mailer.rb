require 'ses'
require 'sns'
require 'ahoy_email'

ActionMailer::Base.add_delivery_method :ses, SES::Base

AhoyEmail.secret_token = Rails.application.secrets.secret_key_base
AhoyEmail.message_model = Message
