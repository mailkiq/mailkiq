require 'fog/aws/models/ses/base'
require 'fog/aws/models/ses/bounce'
require 'fog/aws/models/ses/bounced_recipient'
require 'fog/aws/models/ses/bounced_recipients'
require 'fog/aws/models/ses/bounce_notification'
require 'fog/aws/models/ses/complained_recipient'
require 'fog/aws/models/ses/complained_recipients'
require 'fog/aws/models/ses/complaint'
require 'fog/aws/models/ses/complaint_notification'
require 'fog/aws/models/ses/delivery'
require 'fog/aws/models/ses/delivery_notification'
require 'fog/aws/models/ses/mail'

require 'fog/aws/models/sns/message'
require 'fog/aws/models/sns/messages'
require 'fog/aws/models/sns/message_verifier'
require 'fog/aws/models/sns/notification'

require 'fog/aws/parsers/ses/delete_identity'
require 'fog/aws/requests/ses/delete_identity'

ActionMailer::Base.add_delivery_method :ses, Fog::AWS::SES::Base

Fog::AWS::SES.class_eval do
  request :delete_identity
end
