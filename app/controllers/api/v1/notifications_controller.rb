module API
  module V1
    class NotificationsController < BaseController
      skip_before_action :ensure_correct_media_type
      before_action :authenticate!

      def create
        @sns = Aws::SNS::Message.load request.body.read

        if @sns.subscription_confirmation?
          sns = Aws::SNS::Client.new(current_account.credentials)
          sns.confirm_subscription topic_arn: @sns.topic_arn, token: @sns.token
        elsif @sns.ses?
          return validate_amazon_headers unless own_topic_arn?

          message = Message.find_by! uuid: @sns.mail_id
          message.notifications.create! type: @sns.message_type.downcase,
                                        data: @sns.data.as_json

          current_account.subscribers
                         .where(email: @sns.emails)
                         .update_all(state: Subscriber.states[@sns.state])
        end

        head :ok
      end

      private

      def own_topic_arn?
        request.headers['X-Amz-Sns-Topic-Arn'] == current_account.aws_topic_arn
      end

      def validate_amazon_headers
        render json: { message: 'Something wrong with SNS subscription' }, status: :unauthorized
      end
    end
  end
end
