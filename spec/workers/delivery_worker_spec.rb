require 'rails_helper'

describe DeliveryWorker, type: :worker do
  it { is_expected.to be_processed_in :critical }
  it { is_expected.to save_backtrace }
  it { is_expected.to be_retryable 0 }

  it 'pipeline mail jobs to Redis' do
    campaign = Fabricate.build(:campaign, id: 1)

    expect(campaign).to receive(:account)
    expect(campaign).to receive(:update_column).with(:recipients_count, 2)
    expect(Campaign).to receive(:find).and_return(campaign)
    expect_any_instance_of(Segment).to receive(:jobs_for)
      .with(campaign_id: campaign.id)
      .and_return([[1, 1], [1, 2]])

    expect_any_instance_of(Sidekiq::Queue).to receive(:pause)
    expect_any_instance_of(Sidekiq::Queue).to receive(:unpause)
    expect_any_instance_of(Sidekiq::Queue).to receive(:size).and_return(2)

    expect(Sidekiq::Client).to receive(:push_bulk).and_call_original

    subject.perform(1, nil, nil)

    expect(CampaignWorker).to have_enqueued_job(1, 1)
    expect(CampaignWorker).to have_enqueued_job(1, 2)
  end
end
