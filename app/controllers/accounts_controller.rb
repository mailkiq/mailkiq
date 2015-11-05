class AccountsController < Clearance::UsersController
  def new
    @account = user_from_params
    render template: "accounts/new"
  end

  def create
    @account = user_from_params

    if @account.save
      sign_in @account
      redirect_back_or url_after_create
    else
      render template: "accounts/new"
    end
  end

  private

  def user_params
    params.fetch(:account, {}).permit :name, :email, :time_zone, :password,
      :aws_access_key_id, :aws_secret_access_key
  end
end
