class NotificationsController < ApplicationController
  def create
    json = JSON.parse(request.body.read)
    notification = SNS::Notification.new json

    # 1 - identificar qual conta
    # Account = ??

    # 2 - subscribe automático do SNS
    if notification.subscription_confirmation?
      Excon.get(notification.subscribe_url)
    else
      # 3 - store event on database.
    end

    head :ok
  end
end
