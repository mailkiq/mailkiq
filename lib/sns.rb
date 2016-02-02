require 'fog/aws/ses'

module SNS
  autoload :Message,         'sns/message'
  autoload :Messages,        'sns/messages'
  autoload :Notification,    'sns/notification'
  autoload :MessageVerifier, 'sns/message_verifier'
end
