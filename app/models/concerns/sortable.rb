module Sortable
  def decide_direction(column)
    name = column
    direction = :asc

    if column.start_with? '-'
      name = column.tr('-', '')
      direction = :desc
    end

    [name, direction]
  end

  def sort(column)
    name, direction = decide_direction(column)

    if column_names.include?(name)
      order name => direction
    else
      all
    end
  end
end
