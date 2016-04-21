require 'rails_helper'

describe Delivery, type: :model do
  it { is_expected.to have_attr_accessor :campaign }
  it { is_expected.to have_attr_accessor :tagged_with }
  it { is_expected.to have_attr_accessor :not_tagged_with }

  it { is_expected.to delegate_method(:account).to(:campaign) }
  it { is_expected.to delegate_method(:credits_exceeded?).to(:account) }

  it { expect(described_class.ancestors).to include ActiveModel::Model }

  subject { Fabricate.build :delivery }

  before do
    allow(subject).to receive(:validate_enough_credits).and_return(true)
  end

  describe '#save' do
    it 'enqueues delivery job' do
      expect(Resque).to receive(:enqueue)
        .with(DeliveryWorker, subject.campaign.id, subject.tagged_with,
              subject.not_tagged_with)

      subject.save
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
end
