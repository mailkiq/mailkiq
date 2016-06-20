require 'rouge'

module SubscribersHelper
  COLORS = {
    active: :primary,
    unconfirmed: :default,
    unsubscribed: :default,
    complained: :warning,
    bounced: :danger,
    deleted: :danger
  }.freeze

  def subscriber_state_tag(state)
    variation = COLORS[state.to_sym]
    text = t("simple_form.options.subscriber.state.#{state}")
    content_tag :span, text, class: "label-#{variation}"
  end

  def html_syntax(&block)
    source = capture(&block)
    formatter = Rouge::Formatters::HTMLLegacy.new css_class: 'highlight'
    lexer = Rouge::Lexers::HTML.new
    formatter.format(lexer.lex(source)).html_safe
  end
end
