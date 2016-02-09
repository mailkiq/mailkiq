module API::V1
  class NotificationsController < BaseController
    before_action :authenticate!

    def create
      @message_body = request.body.read
      @verifier = SNS::MessageVerifier.new
      @verifier.authenticate! @message_body

      @json = JSON.parse(@message_body)
      @notification = SNS::Notification.new @json

      if @notification.subscription_confirmation?
        sns = Fog::AWS::SNS.new(current_account.credentials)
        sns.confirm_subscription @notification.topic_arn, @notification.token
      elsif @notification.ses?
        Notification.create! message_uid: @notification.message.mail.id,
                             type: @notification.message.type.downcase,
                             data: @notification.data.as_json
      end

      head :ok
    end
  end
end
