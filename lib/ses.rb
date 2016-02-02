require 'fog/aws/ses'

module SES
  autoload :Base,                  'ses/base'
  autoload :Bounce,                'ses/bounce'
  autoload :BounceNotification,    'ses/bounce_notification'
  autoload :BouncedRecipient,      'ses/bounced_recipient'
  autoload :BouncedRecipients,     'ses/bounced_recipients'
  autoload :ComplainedRecipient,   'ses/complained_recipient'
  autoload :ComplainedRecipients,  'ses/complained_recipients'
  autoload :Complaint,             'ses/complaint'
  autoload :ComplaintNotification, 'ses/complaint_notification'
  autoload :Mail,                  'ses/mail'
  autoload :Delivery,              'ses/delivery'
  autoload :DeliveryNotification,  'ses/delivery_notification'
end
