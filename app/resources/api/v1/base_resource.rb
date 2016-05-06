module API
  module V1
    class BaseResource < JSONAPI::Resource
      abstract

      protected

      def current_account
        context[:current_account]
      end
    end
  end
end
