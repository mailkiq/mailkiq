class UnsubscribesController < ApplicationController
  layout false

  def show
    subscriber_id = Token.decode(params[:token])
    subscriber = Subscriber.find subscriber_id
    subscriber.unsubscribed!
  end
end
