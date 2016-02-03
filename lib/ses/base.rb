module SES
  class Base
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
    end

    def deliver!(mail)
      ses = Fog::AWS::SES.new(settings)
      ses.send_raw_email(mail)
    end
  end
end
