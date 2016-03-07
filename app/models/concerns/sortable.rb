module Sortable
  extend ActiveSupport::Concern

  included do
    scope :recents, -> { order created_at: :desc }
  end

  class_methods do
    def sort(column, direction)
      if column_names.include?(column) && %w(asc desc).include?(direction)
        order column => direction
      else
        recents
      end
    end
  end
end
