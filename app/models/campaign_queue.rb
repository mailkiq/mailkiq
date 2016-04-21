class CampaignQueue
  def initialize(campaign)
    @campaign = campaign
  end

  def name
    "campaign-#{@campaign.id}"
  end

  def push_bulk(jobs)
    Resque.redis.pipelined do
      jobs.each do |args|
        item = Resque.encode(class: 'CampaignWorker', args: args)
        Resque.redis.rpush "queue:#{name}", item
      end

      Resque.watch_queue name
    end
  end

  def clear
    Resque.remove_queue name
    Resque.redis.del "queue:#{name}"
  end
end
