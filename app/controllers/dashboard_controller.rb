class DashboardController < AdminController
  def show
    @quota = QuotaPresenter.new(current_user, view_context)
  end
end
