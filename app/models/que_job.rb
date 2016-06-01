require_dependency 'query'

class QueJob < ActiveRecord::Base
  def self.push_bulk(sql, campaign_id)
    ::Query.execute :queue_jobs, with_clause: sql, campaign_id: campaign_id
  end

  def self.remove_queue(campaign_id)
    where(job_class: 'CampaignJob')
      .where('args::text ILIKE ?', "[#{campaign_id},%").delete_all
  end
end
