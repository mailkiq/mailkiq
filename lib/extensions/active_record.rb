ActiveRecord::Base.instance_eval do
  def [](name)
    arel_table[name]
  end

  alias_method :_, :[]
end

ActiveRecord::Associations::BelongsToAssociation.class_eval do
  def counter_cache_available_in_memory?(counter_cache_name)
    false
  end
end
