module Fog
  module AWS
    class SES
      class Real
        def verify_domain_dkim(domain)
          request(
            'Action' => 'VerifyDomainDkim',
            'Domain' => domain,
            :parser  => Fog::Parsers::AWS::SES::VerifyDomainDkim.new
          )
        end
      end
    end
  end
end
