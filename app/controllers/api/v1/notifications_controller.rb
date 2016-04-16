module API
  module V1
    class NotificationsController < BaseController
      skip_before_action :ensure_correct_media_type
      before_action :authenticate!
      before_action :validate_amazon_headers

      def create
        @manager = NotificationManager.new current_account, request.body.read

        if @manager.subscription_confirmation?
          @manager.confirm
        elsif @manager.ses?
          @manager.create!
        end

        head :ok
      end

      private

      def own_topic_arn?
        request.headers['X-Amz-Sns-Topic-Arn'] == current_account.aws_topic_arn
      end

      def validate_amazon_headers
        render json: { message: 'Something wrong with SNS subscription' },
               status: :unauthorized unless own_topic_arn?
      end
    end
  end
end
