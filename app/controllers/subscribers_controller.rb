class SubscribersController < ApplicationController
  before_action :authenticate_account!

  has_scope :page, default: 1
  has_scope :sort

  def index
    @subscribers = apply_scopes current_account.subscribers
    @subscribers = @subscribers.recents unless current_scopes.key?(:sort)
  end

  def new
    @subscriber = current_account.subscribers.new
  end

  def create
    @subscriber = current_account.subscribers.create subscriber_params
    respond_with @subscriber, location: subscribers_path
  end

  def edit
    @subscriber = current_account.subscribers.find params[:id]
  end

  def update
    @subscriber = current_account.subscribers.find params[:id]
    @subscriber.update subscriber_params
    respond_with @subscriber, location: subscribers_path
  end

  def destroy
    @subscriber = current_account.subscribers.find params[:id]
    @subscriber.destroy
    respond_with @subscriber, location: subscribers_path
  end

  private

  def subscriber_params
    params.require(:subscriber).permit :name, :email, :state, tag_ids: []
  end
end
