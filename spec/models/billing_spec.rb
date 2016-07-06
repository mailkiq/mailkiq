require 'rails_helper'

RSpec.describe Billing, type: :model do
  let(:account) { Fabricate.build :valid_account }

  subject { described_class.new account }

  before do
    allow(account).to receive(:update!) do |attributes|
      account.assign_attributes(attributes)
    end

    VCR.use_cassette(:billing) { subject.process }
  end

  describe '#subscription', vcr: { cassette_name: :subscription } do
    it 'retrieves the subscription for the current customer' do
      subscription = subject.subscription
      expect(subscription.plan_identifier).to eq('essentials_plan')
      expect(subscription.id).to eq(account.iugu_subscription_id)
      expect(subscription.expires_at.to_time).to eq(account.expires_at)
    end
  end

  describe '#plan_credits' do
    it 'gets number of available credits of associated plan' do
      expect(subject)
        .to receive_message_chain(:subscription, :attributes, :dig)
        .with('features', 'emails', 'value')
        .and_return(10)

      expect(subject.plan_credits).to eq(10)
    end
  end

  describe '#customer', vcr: { cassette_name: :customer } do
    it 'retrieves the details of an existing customer' do
      VCR.use_cassette(:billing) { subject.process }

      customer = subject.customer

      expect(customer.id).to eq(account.iugu_customer_id)
      expect(customer.name).to eq(account.name)
      expect(customer.email).to eq(account.email)
    end
  end

  describe '#payment_methods', vcr: { cassette_name: :payment_methods } do
    it 'lists the payment methods for the current customer' do
      payment_methods = subject.payment_methods
      credit_card = payment_methods.sample

      expect(payment_methods).to be_one
      expect(credit_card.description).to eq('Cartão de Crédito')
      expect(credit_card.customer_id).to eq(account.iugu_customer_id)
    end
  end

  describe '#invoices', vcr: { cassette_name: :invoices } do
    it 'lists the invoices for current customer' do
      invoices = subject.invoices
      invoice = invoices.sample

      expect(invoices).to be_one
      expect(invoice.email).to eq(account.email)
      expect(invoice.status).to eq('paid')
      expect(invoice.total_paid_cents).to eq(199_00)
      expect(invoice.customer_id).to eq(account.iugu_customer_id)
    end
  end
end
