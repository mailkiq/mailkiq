class CampaignQueue
  attr_reader :campaign

  def initialize(campaign)
    @campaign = campaign
  end

  def name
    "campaign-#{campaign.id}"
  end

  def push_bulk(jobs)
    Resque.redis.pipelined do
      jobs.each do |args|
        item = Resque.encode(class: 'CampaignWorker', args: args)
        Resque.redis.rpush("queue:#{name}", item)
      end

      Resque.watch_queue name
    end
  end

  def remove
    Resque.remove_queue name
  end

  def self.remove_dead_queues
    Resque.queues.grep(/campaign/).each do |name|
      Resque.remove_queue(name) if Resque.size(name).zero?
    end
  end
end
