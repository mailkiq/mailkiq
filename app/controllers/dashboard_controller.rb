class DashboardController < ApplicationController
  before_action :require_login

  def show
    @quota = QuotaPresenter.new(current_user, view_context)
  end
end
