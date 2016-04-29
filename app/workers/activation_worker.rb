class ActivationWorker
  include Sidekiq::Worker

  sidekiq_options queue: :platform, backtrace: true

  def perform(account_id, method_name)
    account = Account.find account_id
    activation = AccountActivation.new(account)
    activation.send(method_name)
  end
end
