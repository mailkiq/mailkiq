class DomainJob < ApplicationJob
  @priority = 1

  def run(account_id)
    account = Account.find account_id
    account.domains.each(&:identity_update!)
  end
end
