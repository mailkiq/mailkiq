module API
  module V1
    class BaseController < ActionController::Metal
      include AbstractController::Rendering
      include ActionController::ConditionalGet
      include ActionController::Rendering
      include ActionController::Renderers
      include ActionController::StrongParameters
      include AbstractController::Callbacks
      include ActionController::Rescue
      include ActionController::Instrumentation

      use_renderers :json

      protected

      def current_account
        @current_account ||= Account.find_by(api_key: params[:api_key])
      end

      def signed_in?
        current_account.present?
      end

      def authenticate!
        if signed_in?
          Raven.user_context current_account.slice(:id, :name, :email)
        else
          headers['WWW-Authenticate'] = %(Token realm="Application")
          failed_login
        end
      end

      def failed_login
        render json: { message: 'Bad credentials' }, status: :unauthorized
      end
    end
  end
end
