class SubscriptionsController < ApplicationController
  before_action :set_subscriber
  layout false

  def show
  end

  def subscribe
    @subscriber.subscribe!
    redirect_to subscription_path(params[:id])
  end

  def unsubscribe
    @subscriber.unsubscribe!
    redirect_to subscription_path(params[:id])
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find Token.decode(params[:id])
  end
end
