class CampaignQueue
  def initialize(campaign)
    @campaign = campaign
    @queue = Sidekiq::Queue.new(name)
  end

  def clear
    @queue.clear
  end

  def name
    "campaign-#{@campaign.id}"
  end

  def push_bulk(jobs)
    Sidekiq::Client.push_bulk \
      'queue'    => name,
      'class'    => CampaignWorker,
      'args'     => jobs
  end
end
