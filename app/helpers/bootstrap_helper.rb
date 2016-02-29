module BootstrapHelper
  def page_title
    naming = PageMeta::Naming.new(controller)
    t("page_meta.titles.#{naming.controller}.#{naming.action}")
  end

  def nav_link_to(key, path)
    name = t("nav.links.#{key}")
    css_class = 'active' if request.path == path || controller_name.to_sym == key
    content_tag :li, link_to(name, path), class: css_class
  end

  def link_to_delete(path)
    link_to t('actions.delete'), path, method: :delete, data: { confirm: t('actions.confirm') }
  end

  def percentage_badge_tag(number, total)
    value = number.to_f * 100 / (total.zero? ? 1 : total)
    percentage = number_to_percentage(value, precision: 1)
    content_tag :span, percentage, class: 'label label-default'
  end
end
