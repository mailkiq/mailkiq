require 'ses'
require 'sns'

ActionMailer::Base.add_delivery_method :ses, SES::Base
