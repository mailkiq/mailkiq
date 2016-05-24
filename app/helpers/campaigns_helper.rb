module CampaignsHelper
  def percentage_tag(value, css_class: 'percentage-balloon')
    precision = value.zero? || value >= 10 ? 0 : 1
    number = number_to_percentage(value, precision: precision)
    content_tag :span, number, class: css_class
  end
end
