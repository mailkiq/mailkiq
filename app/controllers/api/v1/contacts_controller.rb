module API
  module V1
    class ContactsController < BaseController
      before_action :authenticate!

      def create
        prospect = Prospect.new contact_params
        prospect.save!
        render json: prospect.model, status: :created
      end

      private

      def contact_params
        data = ActiveModelSerializers::Deserialization.jsonapi_parse \
          params, only: [:name, :email]

        data.merge! tag: params[:tag], account_id: current_account.id
      end
    end
  end
end
