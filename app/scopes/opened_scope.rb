class OpenedScope < Scope
  def call
    tagged_campaigns = pluck_campaigns @tagged_with
    untagged_campaigns = pluck_campaigns @not_tagged_with

    return if tagged_campaigns.blank? && untagged_campaigns.blank?

    join_sources = Subscriber.arel_table
                             .join(Message.arel_table, Arel::Nodes::OuterJoin)
                             .on(Message[:subscriber_id].eq(Subscriber[:id]))
                             .join_sources

    @relation = @relation.distinct.joins(join_sources)
    @relation.where! tagged_node(tagged_campaigns) if tagged_campaigns
    @relation.where! untagged_node(untagged_campaigns) if untagged_campaigns
    @relation
  end

  private

  def tagged_node(campaigns)
    Message[:campaign_id].in(campaigns).and(Message[:opened_at].not_eq(nil))
  end

  def untagged_node(campaigns)
    Message[:campaign_id].in(campaigns).and(Message[:opened_at].eq(nil))
  end

  def pluck_campaigns(tags)
    names = tags.map { |tag_name| tag_name.match(/Opened (.*)/).try :[], 1 }
    names.compact!
    Campaign.where(name: names).pluck(:id) if names.any?
  end
end
