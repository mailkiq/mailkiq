require 'resque/tasks'

namespace :resque do
  desc 'Remove dead queues on Redis'
  task clean: :environment do
    CampaignQueue.remove_dead_queues
  end
end
