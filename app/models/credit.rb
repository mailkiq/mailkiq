class Credit
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def remaining
    account.plan_credits - account.used_credits.value
  end

  def exceed?(value)
    remaining < value
  end
end
