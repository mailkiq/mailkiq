class Payment
  def initialize(account)
    @account = account
  end

  def checkout_url(options)
    process(:checkout, options).checkout_url
  end

  def make_recurring
    process :request_payment
    process :create_recurring_profile, period: :monthly,
                                       frequency: 1,
                                       start_at: Time.zone.now
  end

  def checkout_details
    process :checkout_details
  end

  private

  def process(action, options = {})
    options = options.reverse_merge(
      token: @account.paypal_payment_token,
      payer_id: @account.paypal_customer_token,
      description: @account.plan.name,
      amount: @account.plan.price,
      currency: 'BRL'
    )

    response = PayPal::Recurring.new(options).send(action)

    raise response.errors.inspect if response.errors.present?

    response
  end
end
