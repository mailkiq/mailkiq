module Fog
  module AWS
    class SES
      class Real
        # Given a list of identities (email addresses and/or domains), returns
        # the verification status and (for domain identities) the verification
        # token for each identity.
        #
        # ==== Parameters
        # * members<~Array> - A list of identities.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'VerificationAttributes'<~Array>
        #       * 'key'<~String> - Domain name.
        #       * 'VerificationStatus'<~String> - The verification status of the identity.
        #       * 'VerificationToken'<~String> - The verification token for a domain identity.
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def get_identity_verification_attributes(members)
          params = { 'Action' => 'GetIdentityVerificationAttributes' }
          params.merge! Fog::AWS.indexed_param('Identities.member', members)

          request params.merge(
            parser: Fog::Parsers::AWS::SES::GetIdentityVerificationAttributes.new
          )
        end
      end
    end
  end
end
