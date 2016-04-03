class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  responders :flash
  respond_to :html
  before_action :set_raven_context, if: :account_signed_in?
  around_action :set_time_zone, if: :account_signed_in?

  private

  def set_time_zone(&block)
    Time.use_zone(current_account.time_zone, &block)
  end

  def set_raven_context
    Raven.user_context current_account.slice(:id, :name, :email)
  end
end
