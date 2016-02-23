module Fog
  module Parsers
    module AWS
      module SES
        class GetIdentityVerificationAttributes < Fog::Parsers::Base
          def reset
            @response = {
              'ResponseMetadata'       => {},
              'VerificationAttributes' => []
            }
            @entry = {}
          end

          def end_element(name)
            case name
            when 'key', 'VerificationStatus', 'VerificationToken'
              @entry[name] = value
            when 'entry'
              @response['VerificationAttributes'] << @entry
              @entry = {}
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
