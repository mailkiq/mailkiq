class MessageEvent
  def initialize(message, request)
    @message = message
    @request = request
    @should_increment_opens_count = !@message.opened_at?
  end

  def open!
    return false if opened?

    @message.opened_at = Time.zone.now
    @message.referer = @request.referer
    @message.ip_address = @request.remote_ip
    @message.user_agent = @request.user_agent
    @message.save!

    increment :unique_opens_count
  end

  def click!
    return false if clicked?

    @message.clicked_at = Time.zone.now
    @message.opened_at ||= @message.clicked_at
    @message.referer ||= @request.referer
    @message.ip_address ||= @request.remote_ip
    @message.user_agent ||= @request.user_agent
    @message.save!

    increment :unique_clicks_count
    increment :unique_opens_count if @should_increment_opens_count
  end

  def redirect_url
    url = @request.params[:url].to_s
    signature = Signature.hexdigest(url)

    if Signature.secure_compare(@request.params[:signature].to_s, signature)
      url
    else
      '/'
    end
  end

  private

  def opened?
    @message.blank? || @message.opened_at?
  end

  def clicked?
    @message.blank? || @message.clicked_at?
  end

  def increment(counter_name)
    Campaign.increment_counter counter_name, @message.campaign_id
  end
end
