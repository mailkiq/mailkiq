module ApplicationHelper
  def html_class
    "#{controller_name}-controller"
  end

  def dispatcher_route
    aliased_action_name = PageMeta::Action.new(action_name)
    "#{controller_name.titleize}##{aliased_action_name}"
  end

  def page_title
    page_meta.title.simple
  end

  def sortable(column, title)
    current = current_scopes[:sort].to_s
    direction = current.start_with?('-') ? :desc : :asc
    sort = column.dup

    if current.tr('-', '') == column
      css_class = "current #{direction}"
      sort.prepend '-' if direction == :asc
      sort.tr! '-', '' if direction == :desc
    end

    link_to title, { sort: sort }, class: css_class
  end
end
