class Scope
  def initialize(relation, tagged_with, not_tagged_with)
    @relation = relation
    @tagged_with = Array(tagged_with)
    @not_tagged_with = Array(not_tagged_with)
  end
end
