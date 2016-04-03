class PaypalController < ApplicationController
  def thank_you
    @account = Account.new session[:user_params]

    if @account.save_with_payment!
      session.clear
      sign_in @account
      redirect_to signed_in_root_path
    else
      redirect_to sign_up_path, notice: 'Something went wrong with payment.'
    end
  end

  def canceled
  end

  def ipn
  end
end
