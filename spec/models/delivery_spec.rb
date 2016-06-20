require 'rails_helper'

describe Delivery, type: :model do
  let(:campaign) { Fabricate.build :campaign_with_account, id: 10 }

  subject { described_class.new campaign }

  before do
    allow_any_instance_of(Quota).to receive(:exceed?).and_return(false)
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
      .and_return(true)
  end

  describe '#valid?' do
    it 'checks account expiration date and credit limits' do
      expect(campaign).to receive(:account_expired?).and_call_original
      expect(campaign).to receive(:valid?).and_call_original
      expect(subject).to be_valid
    end
  end

  describe '#enqueue' do
    it 'enqueues delivery job' do
      expect(DeliveryJob).to receive(:enqueue).with(campaign.id)
      expect(subject).to receive(:valid?).and_return(true)
      expect(campaign).to receive(:enqueue!).and_yield
      expect(campaign.account).to receive(:increment!)
        .with(:used_credits, subject.count)
      expect(campaign).to receive(:recipients_count=).with(subject.count)
      expect(campaign).to receive(:save!)

      subject.enqueue
    end
  end

  describe '#push_bulk' do
    it 'inserts jobs to the queue table' do
      expect_any_instance_of(ScopeChain).to receive(:to_sql)
      expect(QueJob).to receive(:push_bulk)
        .with(anything, campaign.id)
        .and_return(true)

      subject.push_bulk
    end
  end
end
