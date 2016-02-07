module API::V1
  class NotificationsController < BaseController
    before_action :require_token

    def create
      @message_body = request.body.read
      @verifier = SNS::MessageVerifier.new
      @verifier.authenticate! @message_body

      @json = JSON.parse(@message_body)
      @notification = SNS::Notification.new @json

      if @notification.subscription_confirmation?
        sns = Fog::AWS::SNS.new(@account.credentials)
        sns.confirm_subscription @notification.topic_arn, @notification.token
      else
        @account.notifications.create! message: @notification.message.as_json
      end

      head :ok
    end

    private

    def require_token
      @decoded_token = Token.decode params.require(:token)
      @account = Account.find @decoded_token.fetch(:account_id)
      Raven.user_context @account.slice(:id, :name, :email)
    end
  end
end
