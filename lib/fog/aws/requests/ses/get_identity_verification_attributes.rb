module Fog
  module AWS
    class SES
      class Real
        def get_identity_verification_attributes(members)
          params = { 'Action' => 'GetIdentityVerificationAttributes' }
          params.merge! Fog::AWS.indexed_param('Identities.member', members)

          request params.merge(
            parser: Parsers::AWS::SES::GetIdentityVerificationAttributes.new
          )
        end
      end
    end
  end
end
