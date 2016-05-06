class SubscriptionsController < ApplicationController
  layout false

  def unsubscribe
    subscriber_id = Token.decode(params[:token])
    subscriber = Subscriber.find subscriber_id
    subscriber.unsubscribed!
  end
end
