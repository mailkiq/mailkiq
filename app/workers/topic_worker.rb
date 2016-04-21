class TopicWorker
  @queue = :setups

  def self.perform(account_id, method_name)
    account = Account.find account_id
    account_topic = AccountTopic.new(account)
    account_topic.send(method_name)
  end
end
