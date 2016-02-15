class Query
  def initialize(relation, tagged_with, not_tagged_with)
    @relation = relation
    @tagged_with = tagged_with || []
    @not_tagged_with = not_tagged_with || []
  end

  private

  def subscribers
    Subscriber.arel_table
  end

  def messages
    Message.arel_table
  end
end
