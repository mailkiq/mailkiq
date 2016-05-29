module API
  module V1
    class BaseController < ActionController::Metal
      abstract!

      include AbstractController::Rendering
      include ActionView::Rendering
      include ActionController::UrlFor
      include ActionController::Redirecting
      include ActionController::Rendering
      include ActionController::Renderers::All
      include ActionController::RackDelegation
      include AbstractController::Callbacks
      include ActionController::Serialization
      include ActionController::StrongParameters
      include ActionController::Rescue
      include ActionController::Instrumentation

      protected

      def current_account
        @current_account ||= Account.find_by api_key: params[:api_key]
      end

      def account_signed_in?
        current_account.present?
      end

      def authenticate!
        if account_signed_in?
          Raven.user_context current_account.slice(:id, :name, :email)
        else
          render json: { message: 'Bad credentials' }, status: :unauthorized
        end
      end
    end
  end
end
