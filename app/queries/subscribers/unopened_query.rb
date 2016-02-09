module Subscribers
  class UnopenedQuery
    attr_reader :campaign_id

    def initialize(campaign_id)
      @campaign_id = campaign_id
    end

    def call
      subscribers = Subscriber.arel_table
      messages = Message.arel_table

      subscribers_messages = subscribers.join(messages, Arel::Nodes::OuterJoin)
                             .on(messages[:subscriber_id].eq(subscribers[:id]))
                             .join_sources

      relation = Subscriber.distinct.joins(subscribers_messages)
      relation.where! messages[:campaign_id].eq(campaign_id)
      relation.where! messages[:opened_at].eq(nil)
      relation
    end
  end
end
