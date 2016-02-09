class SubscriptionsController < ApplicationController
  def unsubscribe
    subscriber_id = Token.decode(params[:id])
    subscriber = Subscriber.find subscriber_id
    subscriber.unsubscribed!
  end
end
