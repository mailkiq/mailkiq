class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  responders :flash
  respond_to :html
  before_action :set_raven_context, if: :signed_in?
  around_action :set_time_zone, if: :signed_in?

  def ses
    @ses ||= Fog::AWS::SES.new(current_user.credentials)
  end

  private

  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def set_raven_context
    Raven.user_context current_user.slice(:id, :name, :email)
  end
end
