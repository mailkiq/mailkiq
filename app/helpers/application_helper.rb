module ApplicationHelper
  def html_class
    "#{controller_name}-controller"
  end

  def dispatcher_route
    "#{controller_name.titleize}##{action_name}"
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

  def nav_link_to(key, path)
    name = t("nav.links.#{key}")
    css_class = 'active' if request.path == path || controller_name == key.to_s
    content_tag :li, link_to(name, path), class: css_class
  end

  def icon_link_to(icon, path, options = {})
    options[:class] ||= 'icon'
    options[:data] ||= {}
    options[:data][:balloon] = t("actions.#{icon}")
    options[:data]['balloon-pos'] = 'up'

    if options.delete(:delete)
      options[:method] = :delete
      options[:data][:confirm] = t('actions.confirm')
    end

    link_to content_tag(:span, nil, class: "ss-#{icon}"), path, options
  end

  def link_to_delete(path)
    link_options = { method: :delete, data: { confirm: t('actions.confirm') } }
    link_to t('actions.delete'), path, link_options
  end
end
