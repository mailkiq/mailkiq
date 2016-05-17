require 'rouge'

module SubscribersHelper
  COLORS = {
    active: :primary,
    unconfirmed: :default,
    unsubscribed: :default,
    complained: :warning,
    bounced: :danger,
    deleted: :danger
  }

  def subscriber_state_tag(state)
    variation = COLORS[state.to_sym]
    content_tag :span, state.capitalize, class: "label-#{variation}"
  end

  def highlight_html(&block)
    source = capture(&block)
    formatter = Rouge::Formatters::HTML.new css_class: 'highlight'
    lexer = Rouge::Lexers::HTML.new
    formatter.format(lexer.lex(source)).html_safe
  end
end
