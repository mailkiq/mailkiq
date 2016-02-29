module ApplicationHelper
  def sortable(column, title)
    sort_column = current_scopes.dig(:sort, :column)
    sort_direction = current_scopes.dig(:sort, :direction) || 'asc'

    if column == sort_column
      css_class = "current #{sort_direction}"
      sort_direction = sort_direction == 'asc' ? 'desc' : 'asc'
    end

    sort_params = { column: column, direction: sort_direction }
    link_to title, { sort: sort_params }, class: css_class
  end

  def html_class
    "#{controller_name}-controller"
  end
end
