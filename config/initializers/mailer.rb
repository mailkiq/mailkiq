require 'ses'
require 'sns'
require 'ahoy_email'

ActionMailer::Base.add_delivery_method :ses, SES::Base
