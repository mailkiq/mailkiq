class SubscribersController < ApplicationController
  before_action :authenticate_account!

  has_scope :page, default: 1
  has_scope :sort, default: nil, allow_blank: true do |_, scope, value|
    value.blank? ? scope.recent : scope.sort(value)
  end

  def index
    @subscribers = apply_scopes current_account.subscribers
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
