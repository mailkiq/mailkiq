class AccountsController < Clearance::UsersController
  def new
    @user = Account.new plan_id: params[:plan_id]
  end

  def create
    @user = user_from_params

    if @user.valid?
      session[:user_params] = @user.attributes
      redirect_to checkout_url
    else
      render :new
    end
  end

  private

  def checkout_url
    @user.paypal.checkout_url(
      return_url: paypal_thank_you_url,
      cancel_url: paypal_canceled_url,
      ipn_url: paypal_ipn_url
    )
  end

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
