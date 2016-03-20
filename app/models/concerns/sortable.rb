module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recents, -> { order created_at: :desc }
  end

  class_methods do
    def sort(column)
      name = column
      direction = :asc

      if column.start_with? '-'
        name = column.tr('-', '')
        direction = :desc
      end

      if column_names.include?(name)
        order name => direction
      else
        recents
      end
    end
  end
end
