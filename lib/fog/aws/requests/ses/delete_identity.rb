module Fog
  module AWS
    class SES
      class Real
        def delete_identity(identity)
          request 'Action' => 'DeleteIdentity', 'Identity' => identity
        end
      end
    end
  end
end
