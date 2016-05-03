module API
  module V1
    class SubscribersController < BaseController
      skip_before_action :ensure_correct_media_type
      before_action :authenticate!

      private

      def render_results(operation_results)
        respond_to do |format|
          format.api_json { super operation_results }
          format.html { redirect_to back_url } if back_url
          format.any { head :ok }
        end
      end

      def back_url
        params[:redirect_to] || request.referer
      end
    end
  end
end
