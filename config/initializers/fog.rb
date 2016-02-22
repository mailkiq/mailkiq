require 'fog/models/ses/base'
require 'fog/models/ses/bounce'
require 'fog/models/ses/bounced_recipient'
require 'fog/models/ses/bounced_recipients'
require 'fog/models/ses/bounce_notification'
require 'fog/models/ses/complained_recipient'
require 'fog/models/ses/complained_recipients'
require 'fog/models/ses/complaint'
require 'fog/models/ses/complaint_notification'
require 'fog/models/ses/delivery'
require 'fog/models/ses/delivery_notification'
require 'fog/models/ses/mail'

require 'fog/models/sns/message'
require 'fog/models/sns/messages'
require 'fog/models/sns/message_verifier'
require 'fog/models/sns/notification'

ActionMailer::Base.add_delivery_method :ses, Fog::AWS::SES::Base
