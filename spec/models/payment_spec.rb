require 'rails_helper'

describe Payment, type: :model do
  let(:account) { Fabricate.build :valid_account }

  subject { described_class.new account }

  describe '#checkout_url' do
    it 'generates checkout url' do
      expect_process(:checkout, {})
      subject.checkout_url({})
    end
  end

  describe '#make_recurring' do
    it 'requests payment and create recurring profile' do
      now = Time.zone.now

      expect(Time).to receive(:now).at_least(:once).and_return(now)

      expect_process(:request_payment)
      expect_process(:create_recurring_profile, period: :monthly, frequency: 1,
                                                start_at: now)

      subject.make_recurring
    end
  end

  describe '#checkout_details' do
    it 'fetches checkout details' do
      expect_process(:checkout_details)
      subject.checkout_details
    end
  end

  def expect_process(*args)
    response = double
    allow(response).to receive(:checkout_url)
    expect(subject).to receive(:process)
      .with(*args)
      .and_return(response)
  end
end
