module API
  module V1
    class ConversionsController < BaseController
      before_action :authenticate!

      def create
        prospect = Prospect.new conversion_params
        prospect.save!
        redirect_to params[:redirect_to] || :back
      end

      private

      def conversion_params
        {
          tag: params[:tag],
          email: params.require(:email),
          account_id: current_account.id
        }
      end
    end
  end
end
