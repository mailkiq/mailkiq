module API
  module V1
    class ContactsController < BaseController
      before_action :authenticate!

      def create
        subscriber = current_account.subscribers.build contact_params
        subscriber.merge_tags! params[:tag] if params.key? :tag
        subscriber.save
        ConfirmationJob.enqueue(subscriber)
        render json: subscriber, status: :created
      end

      private

      def contact_params
        ActiveModelSerializers::Deserialization.jsonapi_parse \
          params, only: [:name, :email]
      end
    end
  end
end
