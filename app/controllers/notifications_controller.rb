require 'ses'
require 'sns'

class NotificationsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # before_action :require_token

  def create
    data = AuthToken.decode params.require(:token)
    account = Account.find data[:user_id]

    json = JSON.parse(request.body.read)
    notification = SNS::Notification.new json

    Raven.extra_context notification: json

    fail 'blah'

    # 2 - subscribe automático do SNS
    # if notification.subscription_confirmation?
    #   3 - Measure how many confirmations today.
    #   Excon.get(notification.subscribe_url)
    # else
    #   # 3 - store event on database.
    # end

    # head :ok
  end

  # 1 - authenticate
  # def require_token
  #   sign_in_as account
  # end
end
