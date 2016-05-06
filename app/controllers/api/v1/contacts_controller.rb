module API
  module V1
    class ContactsController < BaseController
      skip_before_action :ensure_correct_media_type
      before_action :authenticate!
      before_action :validate_webhook

      private

      def clickfunnels_webhook_delivery_id
        request.headers['X-Clickfunnels-Webhook-Delivery-Id']
      end

      def clickfunnels_digest
        Digest::MD5.hexdigest("#{request.original_url}#{request.raw_post}")
      end

      def validate_webhook
        unless clickfunnels_webhook_delivery_id == clickfunnels_digest
          render json: { error: 'Forbidden' }, status: :forbidden
        end
      end
    end
  end
end
