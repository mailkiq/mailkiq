class MessagesController < ActionController::Base
  IMAGE = 'R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='

  before_filter :set_message

  def open
    if @message && !@message.opened_at
      @message.opened_at = Time.now
      @message.save!
    end

    send_data Base64.decode64(IMAGE), type: 'image/gif', disposition: 'inline'
  end

  def click
    if @message && !@message.clicked_at
      @message.clicked_at = Time.now
      @message.opened_at ||= @message.clicked_at
      @message.save!
    end

    url = params[:url].to_s
    signature = Signature.hexdigest(url)

    if Signature.secure_compare(params[:signature], signature)
      redirect_to url
    else
      redirect_to root_url
    end
  end

  private

  def set_message
    @message = Message.find_by token: params[:id]
  end
end
