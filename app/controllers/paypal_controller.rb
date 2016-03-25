class PaypalController < ApplicationController
  def checkout
    plan = Plan.find params[:plan_id]
    account = Account.new plan: plan
    redirect_to account.paypal.checkout_url(
      return_url: paypal_thank_you_url,
      cancel_url: paypal_canceled_url,
      ipn_url: paypal_ipn_url
    )
  end

  def thank_you
    @account = Account.new session[:user_params]
    @account.paypal_customer_token = params[:PayerID]
    @account.paypal_payment_token = params[:token]

    if @account.save_with_payment
      session.clear
      sign_in @account
      redirect_to signed_in_root_path
    else
      redirect_to root_path
    end
  end

  def canceled
  end

  def ipn
  end
end
