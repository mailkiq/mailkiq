class DomainWorker
  @queue = :domains

  def self.perform(account_id)
    account = Account.find account_id
    account.domains.each(&:identity_update!)
  end
end
