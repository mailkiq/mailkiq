module API::V1
  class NotificationsController < BaseController
    before_action :validate_amazon_headers
    before_action :authenticate!

    def create
      @message_body = request.body.read
      @verifier = SNS::MessageVerifier.new
      @verifier.authenticate! @message_body
      @sns = SNS::Notification.new JSON.parse(@message_body)

      if @sns.subscription_confirmation?
        sns = Fog::AWS::SNS.new(current_account.credentials)
        sns.confirm_subscription @sns.topic_arn, @sns.token
      elsif @sns.ses?
        Notification.create! message_uid: @sns.message.mail.id,
                             type: @sns.message.type.downcase,
                             data: @sns.data.as_json

        current_account.subscribers.where(email: @sns.emails)
          .update_all state: @sns.state
      end

      head :ok
    end

    private

    def validate_amazon_headers
      amz_sns_topic = request.headers['X-Amz-Sns-Topic-Arn'].to_s
      unless amz_sns_topic.start_with?('arn:aws:sns')
        message = 'Invalid Amazon SES notification.'
        render json: { message: message }, status: :unauthorized
      end
    end
  end
end
