class DashboardController < ApplicationController
  before_action :require_login
  layout 'admin'

  def index
    @quota = QuotaPresenter.new(current_user, view_context)
  end
end
