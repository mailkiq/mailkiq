class Billing
  def initialize(account)
    @account = account
  end

  def process
    return false if invalid?

    create_customer if @account.iugu_customer_id.blank?
    create_payment_method unless @account.iugu?
    create_subscription if @account.iugu_subscription_id.blank?
  end

  def subscription
    @subscription ||= Iugu::Subscription.fetch @account.iugu_subscription_id
  end

  def plan_credits
    subscription.attributes.dig('features', 'emails', 'value')
  end

  def customer
    Iugu::Customer.fetch @account.iugu_customer_id
  end

  def payment_methods
    Iugu::PaymentMethod.search(customer_id: @account.iugu_customer_id).results
  end

  def invoices
    Iugu::Invoice.search(customer_id: @account.iugu_customer_id).results
  end

  def plans
    Iugu::Plan.fetch.results
  end

  def plan_options
    plans.map { |plan| [plan.identifier, plan.name] }
  end

  private

  def invalid?
    @account.invalid? || !@account.credit_card_token || !@account.plan
  end

  def create_customer
    new_customer = Iugu::Customer.create(
      name: @account.name,
      email: @account.email
    )

    @account.update! iugu_customer_id: new_customer.id
  end

  def create_subscription
    new_subscription = Iugu::Subscription.create(
      plan_identifier: @account.plan,
      customer_id: @account.iugu_customer_id,
      only_on_charge_success: true
    )

    return if new_subscription.errors

    @account.iugu_subscription_id = new_subscription.id
    @account.expires_at = new_subscription.expires_at
    @account.save
  end

  def create_payment_method
    Iugu::PaymentMethod.create(
      customer_id: @account.iugu_customer_id,
      description: 'Cartão de Crédito',
      token: @account.credit_card_token,
      set_as_default: true
    )
  end
end
