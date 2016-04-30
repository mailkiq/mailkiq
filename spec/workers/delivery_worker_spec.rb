require 'rails_helper'

describe DeliveryWorker, type: :worker do
  it { is_expected.to be_processed_in :deliveries }
  it { is_expected.to save_backtrace }
  it { is_expected.to be_retryable 0 }

  describe '#perform' do
    it 'pushes jobs to Redis queue' do
      campaign = Fabricate.build :campaign, id: 1

      expect(campaign).to receive(:update_columns).with(kind_of(Hash))
      expect(Campaign).to receive(:find).and_return(campaign)

      expect_any_instance_of(Delivery)
        .to receive_message_chain(:chain_queries, :pluck)
        .and_return([1, 2])

      expect_any_instance_of(Delivery).to receive(:deliver!).and_call_original

      subject.perform(1, nil, nil)

      expect(CampaignWorker).to have_enqueued_job(1, 1)
      expect(CampaignWorker).to have_enqueued_job(1, 2)
    end
  end
end
