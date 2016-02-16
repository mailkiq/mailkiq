class Segment
  attr_reader :account, :tagged_with, :not_tagged_with

  def initialize(options = {})
    @account = options[:account]
    @tagged_with = Array(options[:tagged_with])
    @not_tagged_with = Array(options[:not_tagged_with])
  end

  def jobs(campaign_id:)
    subscriber_ids = subscribers.pluck(:id)
    subscriber_ids.map! { |subscriber_id| [campaign_id, subscriber_id] }
  end

  private

  def stack_relation
    relation = Subscriber.where(account_id: account.id).actived
    [OpenedQuery, TagQuery].each do |klass|
      new_relation = klass.new(relation, tagged_with, not_tagged_with).call
      relation = new_relation if new_relation
    end
    relation
  end

  def subscribers
    stack_relation
  end
end
