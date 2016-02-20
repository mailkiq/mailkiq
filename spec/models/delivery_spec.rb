require 'rails_helper'

describe Delivery, type: :model do
  subject do
    Delivery.new account: Account.new,
                 campaign: Campaign.new(id: 10),
                 tagged_with: ['mulherada a'],
                 not_tagged_with: ['mulherada b']
  end

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
      expect(subject.tags)
        .to eq(['Mulherada A', 'Opened The Truth About Wheat'])
    end
  end
end
