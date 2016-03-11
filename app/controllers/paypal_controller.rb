class PaypalController < ApplicationController
  def checkout
    plan = Plan.find params[:plan_id]
    account = Account.new plan: plan
    redirect_to account.paypal.checkout_url(
      return_url: sign_up_url(plan_id: plan.id),
      cancel_url: root_url
    )
  end
end
