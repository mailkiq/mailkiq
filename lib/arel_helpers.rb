module ArelHelpers
  extend ActiveSupport::Concern

  module ClassMethods
    def [](name)
      arel_table[name]
    end

    alias_method :_, :[]
  end
end
