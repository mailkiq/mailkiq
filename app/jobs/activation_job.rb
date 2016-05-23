class ActivationJob < Que::Job
  @priority = 1

  def run(account_id, method_name)
    account = Account.find account_id
    activation = AccountActivation.new(account)
    activation.send(method_name)
  end
end
