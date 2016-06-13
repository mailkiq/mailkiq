class ConfirmationJob
  def self.enqueue(subscriber)
    automation = subscriber.account.automations.confirmation.first
    return false if automation.nil? || subscriber.invalid?
    CampaignJob.enqueue automation.id, subscriber.id
  end
end
