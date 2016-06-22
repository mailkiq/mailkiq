require 'rails_helper'

describe Quota, type: :model do
  subject { described_class.new account }

  let(:account) { Fabricate.build :paid_account }
  let(:ses) { subject.instance_variable_get :@ses }
  let(:billing) { subject.instance_variable_get :@billing }

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
      expect(subject).to be_exceed(6)
      expect(subject).not_to be_exceed(5)
    end

    it 'checks if account has expired' do
      account.expires_at = 1.day.ago
      expect(account).to receive(:expired?).and_call_original
      expect(subject).to be_exceed(3)
    end
  end

  describe '#use!' do
    it 'increases used credits by the given value' do
      expect(account).to receive(:increment!).with(:used_credits, 10)
      subject.use! 10
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

      timestamp = subject.send_statistics.sample[:timestamp]

      expect(timestamp).to be_instance_of Date
    end
  end
end
