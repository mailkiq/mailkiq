class OpenedQuery < Query
  def call
    tagged_campaigns = pluck_campaigns @tagged_with
    untagged_campaigns = pluck_campaigns @not_tagged_with

    return if tagged_campaigns.blank? && untagged_campaigns.blank?

    subscribers_messages = subscribers.join(messages, Arel::Nodes::OuterJoin)
                           .on(messages[:subscriber_id].eq(subscribers[:id]))
                           .join_sources

    @relation = @relation.distinct.joins(subscribers_messages)
    @relation.where! tagged_node(tagged_campaigns) if tagged_campaigns
    @relation.where! untagged_node(untagged_campaigns) if untagged_campaigns
    @relation
  end

  private

  def tagged_node(campaigns)
    messages[:campaign_id].in(campaigns).and(messages[:opened_at].not_eq(nil))
  end

  def untagged_node(campaigns)
    messages[:campaign_id].in(campaigns).and(messages[:opened_at].eq(nil))
  end

  def pluck_campaigns(tags)
    names = tags.map { |tag_name| tag_name.match(/Opened (.*)/).try :[], 1 }
    names.compact!
    Campaign.where(name: names).pluck(:id) if names.any?
  end
end
