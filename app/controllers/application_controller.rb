class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  responders :flash
  respond_to :html
  before_action :set_user_time_zone, if: :signed_in?
  before_action :set_raven_context, if: :signed_in?

  private

  def set_user_time_zone
    Time.zone = current_user.time_zone if current_user.time_zone?
  end

  def set_raven_context
    Raven.user_context current_user.slice(:id, :name, :email)
  end
end
