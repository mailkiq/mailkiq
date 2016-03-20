module API
  module V1
    class BaseController < JSONAPI::ResourceController
      def current_account
        @current_account ||= Account.find_by(api_key: params[:api_key])
      end

      def context
        { current_account: current_account }
      end

      def signed_in?
        current_account.present?
      end

      def authenticate!
        if signed_in?
          Raven.user_context current_account.slice(:id, :name, :email)
        else
          render json: { message: 'Bad credentials' }, status: :unauthorized
        end
      end
    end
  end
end
