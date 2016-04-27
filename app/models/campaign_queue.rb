class CampaignQueue
  attr_reader :campaign, :queue

  delegate :clear, to: :queue

  def initialize(campaign)
    @campaign = campaign
    @queue = Sidekiq::Queue.new(name)
  end

  def name
    "campaign-#{campaign.id}"
  end

  def push_bulk(jobs)
    Sidekiq::Client.push_bulk \
      'queue'    => name,
      'class'    => CampaignWorker,
      'args'     => jobs
  end
end
