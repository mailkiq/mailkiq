require 'addressable/uri'

class EmailInterceptor
  UTM_PARAMETERS = %w(utm_source utm_medium utm_term utm_content utm_campaign)

  delegate :unsubscribe_url, :open_url, :click_url,
           :image_tag, to: :mailer

  attr_reader :token, :message, :mailer, :utm_params

  def initialize(message, mailer, utm_params = {})
    @token = generate_token
    @message = message
    @mailer = mailer
    @utm_params = utm_params
  end

  def transform!
    set_message_ivars
    substitute_unsubscribe_url
    track_links
    track_open
  end

  private

  def set_message_ivars
    message.instance_variable_set :@_token, @token
    message.instance_variable_set :@_campaign_id, mailer._campaign.id
    message.instance_variable_set :@_subscriber_id, mailer.subscriber.id
  end

  def track_open
    return unless html_part?

    regex = %r{</body>}i
    url = open_url(id: token, format: :gif)
    pixel = image_tag(url, size: '1x1', alt: nil)

    # try to add before body tag
    if raw_source.match(regex)
      raw_source.gsub!(regex, "#{pixel}\\0")
    else
      raw_source << pixel
    end
  end

  def track_links
    return unless html_part?

    doc = Nokogiri::HTML(raw_source)
    doc.css('a[href]').each do |link|
      uri = parse_uri link['href']
      next unless trackable? uri

      # utm params first
      unless skip_attribute? link, 'utm-params'
        params = uri.query_values || {}
        UTM_PARAMETERS.each do |key|
          params[key] ||= utm_params[key.to_sym] if utm_params[key.to_sym]
        end
        uri.query_values = params
        link['href'] = uri.to_s
      end

      next if skip_attribute? link, 'click'

      signature = Signature.hexdigest link['href']
      link['href'] = click_url id: token,
                                       url: link['href'],
                                       signature: signature
    end

    # hacky
    raw_source.sub!(raw_source, doc.to_s)
  end

  def substitute_unsubscribe_url
    token = Token.encode mailer.subscriber.id
    unsubscribe_url = unsubscribe_url(token)

    parts = message.parts.any? ? message.parts : [message]
    parts.each do |part|
      part.body.raw_source.gsub!(/%unsubscribe_url%/i, unsubscribe_url)
    end
  end

  def generate_token
    SecureRandom.urlsafe_base64(32).gsub(/[\-_]/, '').first(32)
  end

  def html_part?
    (message.html_part || message).content_type =~ /html/
  end

  # Filter trackable URIs, i.e. absolute one with http
  def trackable?(uri)
    uri && uri.absolute? && %w(http https).include?(uri.scheme)
  end

  def skip_attribute?(link, suffix)
    attribute = "data-skip-#{suffix}"
    if link[attribute]
      # remove it
      link.remove_attribute(attribute)
      true
    elsif link['href'].to_s =~ /unsubscribe/i
      # try to avoid unsubscribe links
      true
    else
      false
    end
  end

  # Parse href attribute
  # Return uri if valid, nil otherwise
  def parse_uri(href)
    # to_s prevent to return nil from this method
    Addressable::URI.parse(href.to_s)
  rescue
    nil
  end

  def raw_source
    (message.html_part || message).body.raw_source
  end
end
