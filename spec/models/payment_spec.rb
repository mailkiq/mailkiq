require 'rails_helper'

describe Payment, type: :model do
  let(:account) { Fabricate.build :valid_account }

  subject { described_class.new account }

  matcher :process do |*args|
    match do |actual|
      response = double
      allow(response).to receive(:checkout_url)
      expect(actual).to receive(:process)
        .with(*args)
        .and_return(response)
    end
  end

  describe '#checkout_url' do
    it 'generates checkout url' do
      is_expected.to process(:checkout, {})
      subject.checkout_url({})
    end
  end

  describe '#make_recurring' do
    it 'requests payment and create recurring profile' do
      now = Time.zone.now

      expect(Time).to receive(:now).and_return(now)

      is_expected.to process(:request_payment)
      is_expected.to process(:create_recurring_profile, period: :monthly,
                                                        frequency: 1,
                                                        start_at: now)

      subject.make_recurring
    end
  end

  describe '#checkout_details' do
    it 'fetches checkout details' do
      is_expected.to receive(:checkout_details)
      subject.checkout_details
    end
  end
end
