module API
  module V1
    class NotificationsController < BaseController
      before_action :authenticate!

      def create
        @message_body = request.body.read
        @verifier = Fog::AWS::SNS::MessageVerifier.new
        @verifier.authenticate! @message_body
        @sns = Fog::AWS::SNS::Notification.new JSON.parse(@message_body)

        if @sns.subscription_confirmation?
          sns = Fog::AWS::SNS.new(current_account.credentials)
          sns.confirm_subscription @sns.topic_arn, @sns.token
        elsif @sns.ses?
          return validate_amazon_headers unless own_topic_arn?

          Notification.create! message_id: find_message_with_uuid,
                               type: @sns.message.type.downcase,
                               data: @sns.data.as_json

          current_account.subscribers.where(email: @sns.emails)
            .update_all state: Subscriber.states[@sns.state]
        end

        head :ok
      end

      private

      def find_message_with_uuid
        Message.where(uuid: @sns.message.mail.id).pluck(:id).first
      end

      def own_topic_arn?
        request.headers['X-Amz-Sns-Topic-Arn'] == current_account.aws_topic_arn
      end

      def validate_amazon_headers
        render json: { message: 'Something wrong with SNS subscription' }, status: :unauthorized
      end
    end
  end
end
