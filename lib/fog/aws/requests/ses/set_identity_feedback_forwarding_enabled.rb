module Fog
  module AWS
    class SES
      class Real
        def set_identity_feedback_forwarding_enabled(forwarding_enabled, identity)
          request 'Action'            => 'SetIdentityFeedbackForwardingEnabled',
                  'ForwardingEnabled' => forwarding_enabled,
                  'Identity'          => identity
        end
      end
    end
  end
end
