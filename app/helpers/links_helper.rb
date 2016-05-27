module LinksHelper
  def nav_link_to(key, path, link_options = {})
    name = t("nav.links.#{key}")
    css_class = 'active' if request.path == path ||
                            controller_name == key.to_s.pluralize
    content_tag :li, link_to(name, path, link_options), class: css_class
  end

  def action_link_to(key, path, options = {})
    name = t("actions.#{key}")
    options[:class] = "ss-#{key} right"

    if options[:method] == :delete
      options[:data] = { confirm: t('actions.confirm') }
    end

    content_tag :li, link_to(name, path, options)
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
