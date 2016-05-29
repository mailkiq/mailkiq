class ConfirmationJob
  def self.enqueue(subscriber)
    automation = subscriber.account.automations.confirmation.first
    return false if automation.nil?
    CampaignJob.enqueue automation.id, subscriber.id
  end
end
