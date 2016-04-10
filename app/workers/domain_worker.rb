class DomainWorker
  include Sidekiq::Worker

  sidekiq_options queue: :platform, backtrace: true, unique: :until_executing

  def perform(account_id)
    @account = Account.find account_id
    @account.domains.each(&:identity_update!)
  end
end
