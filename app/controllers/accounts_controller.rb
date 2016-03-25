class AccountsController < Clearance::UsersController
  def new
    @user = Account.new plan_id: params[:plan_id]
  end

  def create
    @user = user_from_params

    if @user.valid?
      session[:user_params] = @user.attributes
      redirect_to paypal_checkout_path(plan_id: @user.plan_id)
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
    params.require(:account).permit :name, :email, :plan_id,
                                    :password_confirmation,
                                    :password
  end
end
