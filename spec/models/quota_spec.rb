require 'rails_helper'

describe Quota, type: :model do
  let(:account) { Fabricate.build :account }
  let(:ses) { subject.instance_variable_get :@ses }
  let(:billing) { subject.instance_variable_get :@billing }

  subject { described_class.new account }

  before do
    allow(billing).to receive(:plan_credits).and_return(10)
  end

  describe '#remaining' do
    it 'returns remaining credits' do
      expect(subject.remaining).to eq(5)
    end
  end

  describe '#exceed?' do
    it 'checks if account has enough credits with the given value' do
      account.iugu_customer_id = SecureRandom.uuid
      account.iugu_subscription_id = SecureRandom.uuid
      expect(subject).to be_exceed(6)
      expect(subject).not_to be_exceed(5)
    end
  end

  describe '#send_quota' do
    it 'fetches send quota data' do
      expect(subject.send_quota).to be_instance_of Hash
    end
  end

  describe '#send_statistics' do
    it 'groups data points by day' do
      send_statistics = json :statistics
      send_statistics[:send_data_points].map! do |n|
        n[:timestamp] = Time.parse(n[:timestamp])
        n
      end

      ses.stub_responses :get_send_statistics, send_statistics

      expect(subject.send_statistics.sample[:timestamp]).to be_instance_of Date
    end
  end
end
