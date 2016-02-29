module Sortable
  def sort(column, direction)
    if column_names.include?(column) && %w(asc desc).include?(direction)
      order column => direction
    else
      recents
    end
  end
end
