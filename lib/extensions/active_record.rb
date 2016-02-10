ActiveRecord::Base.instance_eval do
  def [](name)
    arel_table[name]
  end

  alias_method :_, :[]
end
