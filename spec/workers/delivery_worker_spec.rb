require 'rails_helper'

describe DeliveryWorker, type: :worker do
  it { is_expected.to be_processed_in :deliveries }
  it { is_expected.to save_backtrace }
  it { is_expected.to be_retryable 0 }

  describe '#perform' do
    it 'pushes jobs to Redis queue' do
      campaign = Fabricate.build(:campaign, id: 1)
      now = Time.now

      expect(Time).to receive(:now).at_least(:once).and_return(now)
      expect(campaign).to receive(:account)
      expect(campaign).to receive(:update_columns)
        .with(recipients_count: 2, sent_at: now)

      expect(Campaign).to receive(:find).and_return(campaign)
      expect_any_instance_of(Segment).to receive(:jobs_for)
        .with(campaign_id: campaign.id)
        .and_return([[1, 1], [1, 2]])

      expect(campaign.queue).to receive(:pause)
      expect(campaign.queue).to receive(:unpause)

      subject.perform(1, nil, nil)

      expect(CampaignWorker).to have_enqueued_job(1, 1)
      expect(CampaignWorker).to have_enqueued_job(1, 2)
    end
  end
end
