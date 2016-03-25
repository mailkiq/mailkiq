class AccountsController < Clearance::UsersController
  def new
    @account = user_from_params
  end

  def create
    @account = user_from_params

    if @account.valid?
      session[:user_params] = @account.attributes
      redirect_to paypal_checkout_path(plan_id: @account.plan_id)
    else
      render :new
    end
  end

  private

  def user_from_params
    super.tap do |resource|
      resource.plan_id ||= params[:plan_id]
      resource.aws_access_key_id = ENV['MAILKIQ_ACCESS_KEY_ID']
      resource.aws_secret_access_key = ENV['MAILKIQ_SECRET_ACCESS_KEY']
    end
  end

  def user_params
    params.fetch(:account, {}).permit :name, :email, :time_zone, :password,
                                      :password_confirmation,
                                      :paypal_customer_token,
                                      :paypal_payment_token,
                                      :plan_id
  end
end
