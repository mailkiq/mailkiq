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
      include ActionController::Serialization
      include ActionController::StrongParameters
      include ActionController::ForceSSL
      include AbstractController::Callbacks
      include ActionController::Rescue
      include ActionController::Instrumentation

      rescue_from ActiveRecord::RecordNotUnique, with: :record_not_unique

      force_ssl if: :ssl_configured?

      protected

      def ssl_configured?
        !Rails.env.development?
      end

      def record_not_unique(exception)
        Appsignal.add_exception(exception)
        message = 'Email address already exists'
        render json: { message: message }, status: :unprocessable_entity
      end

      def current_account
        @current_account ||= Account.find_by api_key: params[:api_key]
      end

      def account_signed_in?
        current_account.present?
      end

      def authenticate!
        if account_signed_in?
          Appsignal.tag_request current_account.slice(:id, :name, :email)
        else
          render json: { message: 'Bad credentials' }, status: :unauthorized
        end
      end
    end
  end
end
