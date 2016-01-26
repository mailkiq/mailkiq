class BouncesController < ApplicationController
  def create
    json = JSON.parse(request.body.read)
    notification = SQS::Notification.new json

    if notification.complaint? || notification.bounce?
      User.where(email: notification.emails).update_all newsletter: false
    end

    head :ok
  end
end
