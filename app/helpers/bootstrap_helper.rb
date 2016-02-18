module BootstrapHelper
  def page_title
    naming = PageMeta::Naming.new(controller)
    t("page_meta.titles.#{naming.controller}.#{naming.action}")
  end

  def nav_link_to(name, path)
    css_class = 'active' if request.path == path
    content_tag :li, link_to(name, path), role: 'presentation', class: css_class
  end

  def icon_link_to(path, options = {})
    icon = options.delete(:icon)
    options[:class] = 'hidden-md hidden-lg'
    link_to tag(:span, class: "glyphicon glyphicon-#{icon}"), path, options
  end

  def trash_link_to(path)
    icon_link_to path, icon: :trash, method: :delete,
                       data: { confirm: t('actions.confirm') }
  end

  def percentage_badge_tag(number, total)
    value = number.to_f * 100 / (total.zero? ? 1 : total)
    percentage = number_to_percentage(value, precision: 1)
    content_tag :span, percentage, class: 'label label-default'
  end
end
