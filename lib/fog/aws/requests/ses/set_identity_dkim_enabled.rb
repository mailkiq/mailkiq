module Fog
  module AWS
    class SES
      class Real
        def set_identity_dkim_enabled(dkim_enabled, identity)
          request 'Action'      => 'SetIdentityDkimEnabled',
                  'DkimEnabled' => dkim_enabled,
                  'Identity'    => identity
        end
      end
    end
  end
end
