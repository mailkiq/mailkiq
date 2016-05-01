module API
  module V1
    class SubscribersController < BaseController
      skip_before_action :ensure_correct_media_type
      before_action :authenticate!

      private

      def render_results(operation_results)
        return super(operation_results) unless params.key? :redirect_to
        redirect_to params[:redirect_to]
      end
    end
  end
end
