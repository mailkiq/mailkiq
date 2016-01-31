require 'fog/aws/ses'

module SES
  class Base
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
      @settings[:persistent] = true
      @settings[:connection_options] = { thread_safe_sockets: false }

      @pool_options = {}
      @pool_options[:size] = ENV['AWS_SES_POOL_SIZE'] || 10
      @pool_options[:timeout] = ENV['AWS_SES_POOL_TIMEOUT'] || 5
    end

    def pool
      Thread.current[:_ses_pool] ||= ConnectionPool.new(@pool_options) do
        Fog::AWS::SES.new(settings)
      end
    end

    def deliver!(mail)
      pool.with do |ses|
        ses.send_raw_email(mail)
      end
    end
  end
end
