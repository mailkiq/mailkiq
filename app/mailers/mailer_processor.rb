require 'addressable/uri'

class MailerProcessor
  delegate :mail, :subscription_token, :token, :utm_params, to: :@email

  def initialize(email)
    @email = email
  end

  def transform!
    return unless html_part?
    expand_variables
    track_links
    track_open
  end

  private

  def body
    (mail.html_part || mail).body
  end

  def html_part?
    (mail.html_part || mail).content_type =~ /html/
  end

  def trackable?(uri)
    uri && uri.absolute? && %w(http https).include?(uri.scheme)
  end

  def helpers
    ActionController::Base.helpers
  end

  def url_for(params = {})
    params.merge! ActionMailer::Base.default_url_options
    Rails.application.routes.url_for(params)
  end

  def click_url(params = {})
    params[:controller] = :tracks
    params[:action] = :click
    url_for params
  end

  def open_url
    url_for controller: :tracks, action: :open, id: token, format: :gif
  end

  def unsubscribe_url
    url_for controller: :subscriptions,
            action: :unsubscribe,
            token: CGI.escape(subscription_token)
  end

  def track(href)
    uri = Addressable::URI.parse href
    return unless trackable? uri
    uri.query_values = (uri.query_values || {}).merge(utm_params)
    url = uri.to_s
    click_url id: token, signature: Signature.hexdigest(url), url: url
  end

  def parse(html)
    if html =~ /<body[^<>]*>/i
      Nokogiri::HTML(html)
    else
      Nokogiri::HTML.fragment(html)
    end
  end

  def track_links
    doc = parse(body.raw_source)
    doc.css('a[href]').each do |node|
      href = node[:href].to_s
      next if href =~ /unsubscribe/i
      href = track(href)
      node[:href] = href if href
    end

    remove_doctype = body.raw_source.match(/!doctype/i).nil?
    html = doc.to_s
    html.gsub!(/<!doctype[^<>]*>(\n)?/i, '') if remove_doctype

    # hacky
    body.raw_source.sub! body.raw_source, html
  end

  def track_open
    raw_source = body.raw_source
    regex = %r{</body>}i
    pixel = helpers.image_tag(open_url, size: '1x1', alt: '')

    # try to add before body tag
    if raw_source.match(regex)
      raw_source.gsub!(regex, "#{pixel}\\0")
    else
      raw_source << pixel
    end
  end

  def expand_variables
    parts = mail.parts.any? ? mail.parts : [mail]
    parts.each do |part|
      part.body.raw_source.gsub!(/%unsubscribe_url%/i, unsubscribe_url)
    end
  end
end
