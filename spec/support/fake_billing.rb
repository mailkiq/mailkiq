require_relative 'helpers'

class FakeBilling
  extend WebMock::API
  extend Helpers

  def self.stub!
    stub_request(:post, 'https://api.iugu.com/v1/customers')
      .with(body: { name: 'John Doe', email: 'account0@example.com' })
      .to_return(body: fixture_file('iugu_customer.json'))

    stub_request(:post, 'https://api.iugu.com/v1/customers/E89854FBE69A475798D57AF0B8427CB8/payment_methods')
      .with(body: json(:iugu_create_payment_method))
      .to_return(body: fixture_file('iugu_payment_method.json'))

    stub_request(:post, 'https://api.iugu.com/v1/subscriptions')
      .with(body: json(:iugu_create_subscription))
      .to_return(body: fixture_file('iugu_subscription.json'))

    stub_request(:get, 'https://api.iugu.com/v1/invoices')
      .with(body: { customer_id: 'E89854FBE69A475798D57AF0B8427CB8' })
      .to_return(body: fixture_file('iugu_invoices.json'))

    stub_request(:get, 'https://api.iugu.com/v1/customers/E89854FBE69A475798D57AF0B8427CB8/payment_methods')
      .with(body: { customer_id: 'E89854FBE69A475798D57AF0B8427CB8' })
      .to_return(body: fixture_file('iugu_payment_method.json'))

    stub_request(:get, 'https://api.iugu.com/v1/customers/E89854FBE69A475798D57AF0B8427CB8')
      .to_return(body: fixture_file('iugu_customer.json'))

    stub_subscription
  end

  def self.stub_subscription(overrides = {})
    subscription = json(:iugu_subscription).merge!(overrides).to_json

    stub_request(:get, 'https://api.iugu.com/v1/subscriptions/ABC1C0EA9F4341568AA23EC5B5043743')
      .to_return(body: subscription)

    stub_request(:get, 'https://api.iugu.com/v1/subscriptions/abc1c0ea-9f43-4156-8aa2-3ec5b5043743')
      .to_return(body: subscription)
  end
end
