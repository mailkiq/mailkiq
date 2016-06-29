require_dependency 'signature'

class MessageEvent
  def initialize(message, params)
    @message = message
    @params = params
    @should_increment_opens_count = !@message.opened_at? if @message.present?
  end

  def open!
    return false if opened?

    @message.opened_at = Time.zone.now
    @message.referer = @params[:referer]
    @message.ip_address = @params[:remote_ip]
    @message.user_agent = @params[:user_agent]
    @message.save!

    increment :unique_opens_count
  end

  def click!
    return false if clicked?

    @message.clicked_at = Time.zone.now
    @message.opened_at ||= @message.clicked_at
    @message.referer ||= @params[:referer]
    @message.ip_address ||= @params[:remote_ip]
    @message.user_agent ||= @params[:user_agent]
    @message.save!

    increment :unique_clicks_count
    increment :unique_opens_count if @should_increment_opens_count
  end

  def redirect_url
    signature = Signature.hexdigest @params[:url]

    if Signature.secure_compare(@params[:signature], signature)
      @params[:url]
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
