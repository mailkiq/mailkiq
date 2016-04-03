class DashboardController < ApplicationController
  before_action :authenticate_account!

  def show
    @quota = QuotaPresenter.new(current_account, view_context)
  end
end
