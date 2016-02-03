require 'ses'
require 'sns'

module API::V1
  class NotificationsController < BaseController
    # before_action :require_amazon_headers
    before_action :require_token

    def create
      # TODO: can't lose any notification!!!
      # TODO: move to a background process
      # TODO: measure all the things!

      # Verify the authenticity of messages.
      @message_body = request.body.read
      @verifier = SNS::MessageVerifier.new
      @verifier.authenticate! @message_body

      # Parse message
      @json = JSON.parse(@message_body)
      @notification = SNS::Notification.new @json

      # Automatic subscription confirmation.
      if @notification.subscription_confirmation?
        sns = Fog::AWS::SNS.new(@account.credentials)
        sns.confirm_subscription @notification.topic_arn, @notification.token
      else
        @account.notifications.create! message: @notification.message.as_json
      end

      head :ok
    end

    private

    # def require_amazon_headers
    #   TODO: Validate X-Amz-Sns-Message-Type header.
    #   TODO: Validate X-Amz-Sns-Topic-Arn header.
    # end

    def require_token
      @decoded_token = Token.decode params.require(:token)
      @account = Account.find @decoded_token.fetch(:account_id)
      Raven.user_context @account.slice(:id, :name, :email)
    end
  end
end
