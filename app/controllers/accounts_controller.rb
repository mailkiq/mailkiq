class AccountsController < Clearance::UsersController
  def new
    @account = user_from_params

    if params[:PayerID]
      @account.plan_id = params[:plan_id]
      @account.paypal_customer_token = params[:PayerID]
      @account.paypal_payment_token = params[:token]
      @account.email = @account.paypal.checkout_details.email
    end

    render template: 'accounts/new'
  end

  def create
    @account = user_from_params

    if @account.save_with_payment
      sign_in @account
      redirect_back_or url_after_create
    else
      render template: 'accounts/new'
    end
  end

  private

  def user_params
    params.fetch(:account, {}).permit :name, :email, :time_zone, :password,
                                      :aws_access_key_id,
                                      :aws_secret_access_key,
                                      :paypal_customer_token,
                                      :paypal_payment_token,
                                      :plan_id
  end
end
