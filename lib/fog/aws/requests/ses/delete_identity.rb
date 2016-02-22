module Fog
  module AWS
    class SES
      class Real
        require 'fog/aws/parsers/ses/delete_identity'

        # Deletes the specified identity (email address or domain) from the list
        # of verified identities.
        #
        # ==== Parameters
        # * identity<~String> - The identity to be removed.
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_identity(identity)
          request 'Action'   => 'DeleteIdentity',
                  'Identity' => identity,
                  :parser    => Fog::Parsers::AWS::SES::DeleteIdentity.new
        end
      end
    end
  end
end
