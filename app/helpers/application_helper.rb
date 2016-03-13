module ApplicationHelper
  def html_class
    "#{controller_name}-controller"
  end

  def dispatcher_route
    "#{controller_name.titleize}##{action_name}"
  end

  def page_title
    naming = PageMeta::Naming.new(controller)
    t("page_meta.titles.#{naming.controller}.#{naming.action}")
  end

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

  def nav_link_to(key, path)
    name = t("nav.links.#{key}")
    css_class = 'active' if request.path == path || controller_name == key.to_s
    content_tag :li, link_to(name, path), class: css_class
  end

  def icon_link_to(icon, path, options = {})
    options[:data] ||= {}
    options[:class] = 'icon'

    if options.delete(:delete)
      options[:method] = :delete
      options[:data][:confirm] = t('actions.confirm')
    end

    if options.key?(:title)
      options[:data][:balloon] = options.delete(:title)
      options[:data]['balloon-pos'] = 'up'
    end

    link_to content_tag(:span, nil, class: "ss-#{icon}"), path, options
  end

  def link_to_delete(path)
    link_options = { method: :delete, data: { confirm: t('actions.confirm') } }
    link_to t('actions.delete'), path, link_options
  end
end
