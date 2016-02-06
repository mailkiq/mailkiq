module BootstrapHelper
  def nav_link_to(name, path)
    css_class = 'active' if request.path == path
    content_tag :li, link_to(name, path), role: 'presentation', class: css_class
  end

  def icon_link_to(path, options = {})
    icon = options.delete(:icon)
    options[:class] = 'hidden-md hidden-lg'
    link_to tag(:span, class: "glyphicon glyphicon-#{icon}"), path, options
  end

  def page_title
    naming = PageMeta::Naming.new(controller)
    t("page_meta.titles.#{naming.controller}.#{naming.action}")
  end
end
