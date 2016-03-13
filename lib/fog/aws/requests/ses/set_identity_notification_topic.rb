module Fog
  module AWS
    class SES
      class Real
        def set_identity_notification_topic(identity, notification_type, sns_topic)
          request 'Action' => 'SetIdentityNotificationTopic',
                  'NotificationType' => notification_type,
                  'SnsTopic' => sns_topic,
                  'Identity' => identity
        end
      end
    end
  end
end
