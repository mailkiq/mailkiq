module Fog
  module Parsers
    module AWS
      module SES
        class VerifyDomainDkim < Fog::Parsers::Base
          def reset
            @response = {
              'ResponseMetadata' => {},
              'DkimTokens'       => []
            }
          end

          def end_element(name)
            case name
            when 'member'
              @response['DkimTokens'] << value
            when 'RequestId'
              @response['ResponseMetadata'][name] = value
            end
          end
        end
      end
    end
  end
end
