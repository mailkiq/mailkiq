require 'rails_helper'

describe Delivery, type: :model do
  it { is_expected.to have_attr_accessor :account }
  it { is_expected.to have_attr_accessor :campaign }
  it { is_expected.to have_attr_accessor :tagged_with }
  it { is_expected.to have_attr_accessor :not_tagged_with  }

  it { expect(described_class.ancestors).to include ActiveModel::Model }

  subject { Fabricate.build :delivery }

  describe '#save' do
    it 'enqueue delivery job' do
      expect(DeliveryWorker).to receive(:perform_async)
        .with(subject.campaign.id, subject.tagged_with, subject.not_tagged_with)

      subject.save
    end
  end

  describe '#tags' do
    it 'return static and dynamic tags' do
      tag = Fabricate.build(:tag)
      campaign = Fabricate.build(:campaign)

      expect(subject.account).to receive(:tags).and_return([tag])
      expect(subject.account).to receive(:campaigns).and_return([campaign])
      expect(subject.tags).to eq([
        'Mulherada A', 'Opened The Truth About Wheat'
      ])
    end
  end
end
