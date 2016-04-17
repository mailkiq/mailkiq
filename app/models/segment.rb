class Segment
  QUERIES = [OpenedScope, TagScope].freeze

  include ActiveModel::Model

  attr_accessor :account
  attr_reader :tagged_with, :not_tagged_with

  def tagged_with=(value)
    @tagged_with = Array(value)
  end

  def not_tagged_with=(value)
    @not_tagged_with = Array(value)
  end

  def jobs_for(campaign_id:)
    subscriber_ids = chain_queries.pluck(:id)
    subscriber_ids.map! { |subscriber_id| [campaign_id, subscriber_id] }
  end

  delegate :count, to: :chain_queries

  private

  def chain_queries
    relation = Subscriber.where(account_id: account.id).actived
    QUERIES.each do |klass|
      new_relation = klass.new(relation, tagged_with, not_tagged_with).call
      relation = new_relation if new_relation
    end
    relation
  end
end
