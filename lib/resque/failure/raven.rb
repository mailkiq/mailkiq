module Resque
  module Failure
    class Raven < Base
      def self.count(_queue = nil, _class_name = nil)
        Stat[:failed]
      end

      def save
        ::Raven.capture_exception(exception, extra: {
          payload_class: payload['class'].to_s,
          payload_args: payload['args'].inspect
        })
      end
    end
  end
end
