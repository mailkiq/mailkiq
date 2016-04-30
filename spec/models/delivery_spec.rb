require 'rails_helper'

describe Delivery, type: :model do
  it { is_expected.to have_attr_accessor :campaign }
  it { is_expected.to have_attr_accessor :tagged_with }
  it { is_expected.to have_attr_accessor :not_tagged_with }

  it { is_expected.to delegate_method(:account).to(:campaign) }
  it { is_expected.to delegate_method(:quota_exceed?).to(:account) }

  it { expect(described_class.ancestors).to include ActiveModel::Model }
  it { expect(Delivery::QUERIES).to eq([OpenedScope, TagScope]) }

  subject { Fabricate.build :delivery }

  before do
    allow(subject).to receive(:validate_enough_credits).and_return(true)
  end

  describe '#initialize' do
    it 'coerses string to array' do
      subject.tagged_with = 'blah'
      subject.not_tagged_with = 'blah b'
      expect(subject.tagged_with).to eq(['blah'])
      expect(subject.not_tagged_with).to eq(['blah b'])
    end
  end

  describe '#save' do
    it 'enqueues delivery job' do
      expect(DeliveryWorker).to receive(:perform_async)
        .with(subject.campaign.id, subject.tagged_with, subject.not_tagged_with)

      subject.save
    end
  end

  describe '#deliver!' do
    it 'generates arguments for bulk processing' do
      now = Time.now

      expect(Time).to receive(:now).at_least(:once).and_return(now)
      expect(subject).to receive_message_chain(:chain_queries, :pluck)
        .and_return([2, 3, 4])

      expect(Sidekiq::Client).to receive(:push_bulk)
        .with('queue' => subject.campaign.queue_name,
              'class' => CampaignWorker,
              'args'  => [[1, 2], [1, 3], [1, 4]])
        .and_call_original

      expect(subject.campaign).to receive(:update_columns)
        .with(recipients_count: 3, sent_at: now)

      subject.deliver!
    end
  end

  describe '#opened_campaign_names' do
    it 'returns opened campaign names' do
      expect(subject.account)
        .to receive_message_chain(:campaigns, :sent, :pluck)
        .and_return(['Blah'])

      expect(subject.opened_campaign_names).to eq(['Opened Blah'])
    end
  end

  describe '#tags' do
    it 'returns segmentation tags' do
      tag = Fabricate.build(:tag)

      expect(subject.account).to receive(:tags).and_return([tag])
      expect(subject).to receive(:opened_campaign_names)
        .and_return(['Opened The Truth About Wheat'])

      expect(subject.tags)
        .to eq(['Mulherada A', 'Opened The Truth About Wheat'])
    end
  end

  describe '#chain_queries' do
    it 'calls registered query objects' do
      relation = double
      subject.campaign.account.id = 10
      expect(relation).to receive(:actived).and_return(relation)
      expect(Subscriber).to receive(:where).with(account_id: 10)
        .and_return(relation)

      Delivery::QUERIES.each do |klass|
        expect_any_instance_of(klass).to receive(:call)
        expect(klass).to receive(:new)
          .with(relation, subject.tagged_with, subject.not_tagged_with)
          .and_call_original
      end

      expect(subject.send(:chain_queries)).to eq(relation)
    end
  end
end
