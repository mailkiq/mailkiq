class CampaignQueue
  attr_reader :queue

  delegate :pause, :unpause, :clear, to: :queue

  def initialize(campaign)
    @campaign = campaign
    @queue = Sidekiq::Queue[name]
  end

  def name
    "campaign-#{@campaign.id}"
  end

  def push_bulk(jobs)
    Sidekiq::Client.push_bulk 'queue' => name,
                              'class' => CampaignWorker,
                              'args'  => jobs
  end
end
