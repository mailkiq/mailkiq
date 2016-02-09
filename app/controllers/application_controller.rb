class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  responders :flash
  respond_to :html
  prepend_before_action :set_raven_context

  def set_raven_context
    Raven.user_context current_user.slice(:id, :name, :email) if signed_in?
  end
end
