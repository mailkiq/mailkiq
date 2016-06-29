require 'addressable/uri'
require_dependency 'instrumentable'
require_dependency 'signature'

class MessageRenderer
  include Instrumentable

  def initialize(message)
    @message = message
    @html = message.html_text.dup
    @text = message.plain_text.dup
  end

  def render!
    expand_variables! @html unless @html.blank?
    expand_variables! @text unless @text.blank?

    return if @html.blank?

    track_open
    track_links
    self
  end

  def to_html
    @html
  end

  def to_text
    @text
  end

  private

  def utm_params
    { utm_medium: :email,
      utm_source: :mailkiq,
      utm_campaign: @message.campaign_name.parameterize }
  end

  def document
    @document ||= if @html =~ /<body[^<>]*>/i
                    Nokogiri::HTML(@html)
                  else
                    Nokogiri::HTML.fragment(@html)
                  end
  end

  def track(href)
    uri = Addressable::URI.parse href
    return unless uri && uri.absolute? && %w(http https).include?(uri.scheme)
    uri.query_values = (uri.query_values || {}).merge(utm_params)
    url = uri.to_s
    click_url id: @message.token, signature: Signature.hexdigest(url), url: url
  end

  def track_links
    document.css('a[href]').each do |node|
      href = node[:href].to_s
      next if href =~ /unsubscribe/i
      href = track(href)
      node[:href] = href if href
    end

    html = document.to_s
    html.gsub!(/<!doctype[^<>]*>(\n)?/i, '') if @html.match(/!doctype/i).nil?

    @html = html
  end

  def track_open
    regex = %r{</body>}i
    pixel = ActionController::Base.helpers.image_tag open_url,
                                                     size: '1x1',
                                                     alt: ''

    # try to add before body tag
    if @html.match(regex)
      @html.gsub!(regex, "#{pixel}\\0")
    else
      @html << pixel
    end
  end

  def url(params = {})
    params.merge! ActionMailer::Base.default_url_options
    Rails.application.routes.url_for(params)
  end

  def click_url(params = {})
    url params.merge!(controller: :tracks, action: :click)
  end

  def open_url
    url controller: :tracks, action: :open, id: @message.token, format: :gif
  end

  def subscribe_url
    url controller: :subscriptions, action: :subscribe, id: @message.subscription_token
  end

  def unsubscribe_url
    url controller: :subscriptions, action: :unsubscribe, id: @message.subscription_token
  end

  def expand_variables!(mime)
    mime.gsub!(/%([a-zA-Z]\w*)%/) do |var_name|
      var_name.tr!('%', '')
      send var_name if var_name.end_with?('_url') && respond_to?(var_name, true)
    end
  end

  instrument_method :track_open, 'track_open.message_renderer'
  instrument_method :track_links, 'track_links.message_renderer'
end
