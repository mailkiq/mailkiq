class TagScope < Scope
  def call
    with_tags = pluck_tag_ids @tagged_with
    without_tags = pluck_tag_ids @not_tagged_with
    return if with_tags.blank? && without_tags.blank?

    @relation.joins! join_sources
    @relation.where! Tagging[:tag_id].in(with_tags) if with_tags.present?
    @relation.where! Arel::Nodes::Grouping.new(
      Tagging[:tag_id].not_in(without_tags).or(Tagging[:tag_id].eq(nil))
    ) if without_tags.present?

    @relation
  end

  private

  def join_sources
    Subscriber.arel_table
              .join(Tagging.arel_table, Arel::Nodes::OuterJoin)
              .on(Tagging[:subscriber_id].eq(Subscriber[:id]))
              .join_sources
  end

  def pluck_tag_ids(tags)
    account_id = @relation.where_values_hash['account_id']
    names = tags.reject { |tag_name| tag_name.start_with? 'Opened' }
    Tag.where(account_id: account_id, name: names).pluck(:id) if names.any?
  end
end
