class DeliveryWorker
  include Sidekiq::Worker

  sidekiq_options queue: :critical, backtrace: true, retry: 0

  def perform(campaign_id, tagged_with, not_tagged_with)
    campaign = Campaign.find campaign_id
    segment = Segment.new account: campaign.account,
                          tagged_with: tagged_with,
                          not_tagged_with: not_tagged_with

    jobs = segment.jobs_for(campaign_id: campaign_id)
    jobs.in_groups_of(50_000, false).each do |group|
      Sidekiq::Client.push_bulk 'queue' => campaign.queue_name,
                                'class' => CampaignWorker,
                                'args'  => group
    end
  end
end
