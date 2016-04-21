require 'rails_helper'

describe DeliveryWorker do
  describe '#perform' do
    it 'pushes jobs to Redis queue' do
      campaign = Fabricate.build(:campaign, id: 1)
      now = Time.now

      expect(Time).to receive(:now).at_least(:once).and_return(now)
      expect(campaign).to receive(:update_columns)
        .with(recipients_count: 2, sent_at: now)

      expect(Campaign).to receive(:find).and_return(campaign)
      expect_any_instance_of(Delivery).to receive(:jobs)
        .and_return([[1, 1], [1, 2]])

      described_class.perform(1, nil, nil)
    end
  end
end
