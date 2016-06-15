require 'rails_helper'

describe Delivery, type: :model do
  let(:campaign) { Fabricate.build :campaign_with_account, id: 10 }

  subject { described_class.new campaign }

  before do
    allow_any_instance_of(Quota).to receive(:exceed?).and_return(false)
    allow_any_instance_of(DomainValidator).to receive(:validate_each)
      .and_return(true)
  end

  it { expect(Delivery::SCOPES).to eq([OpenedScope, TagScope]) }

  describe '#tags' do
    it 'returns segmentation tags' do
      tag = Fabricate.build(:tag)

      expect(campaign.account).to receive(:tags).and_return([tag])
      expect(campaign.account)
        .to receive_message_chain(:campaigns, :sent, :pluck).with(:name)
        .and_return(['The Truth About Wheat'])

      expect(subject.tags)
        .to eq(['Mulherada A', 'Opened The Truth About Wheat'])
    end
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
      expect(subject).to receive_message_chain(:chain_scopes, :to_sql)
      expect(QueJob).to receive(:push_bulk)
        .with(anything, campaign.id)
        .and_return(true)

      subject.push_bulk
    end
  end

  describe '#chain_scopes' do
    it 'calls registered query objects' do
      relation = double('relation')

      expect(Subscriber).to receive_message_chain(:activated, :where)
        .with(account_id: campaign.account_id)
        .and_return(relation)

      Delivery::SCOPES.each do |klass|
        expect_any_instance_of(klass).to receive(:call)
        expect(klass).to receive(:new).with(relation, campaign)
          .and_call_original
      end

      expect(subject.send(:chain_scopes)).to eq(relation)
    end
  end
end
