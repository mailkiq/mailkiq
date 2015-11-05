class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  responders :flash
  respond_to :html
end
