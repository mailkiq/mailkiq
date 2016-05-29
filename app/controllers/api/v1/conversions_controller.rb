module API
  module V1
    class ConversionsController < BaseController
      before_action :authenticate!

      def create
        subscriber = current_account.subscribers.build conversion_params
        subscriber.merge_tags! params[:tag] if params.key? :tag
        subscriber.save
        redirect_to params[:redirect_to] || :back
      end

      private

      def conversion_params
        { email: params.require(:email) }
      end
    end
  end
end
