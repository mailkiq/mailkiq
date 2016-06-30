class TracksController < ApplicationController
  before_action :set_message

  def open
    @message_event = MessageEvent.new @message, track_params
    @message_event.open!
    send_data DECODED_PIXEL, type: 'image/gif', disposition: :inline
  end

  def click
    @message_event = MessageEvent.new @message, track_params
    @message_event.click!
    redirect_to @message_event.redirect_url
  end

  private

  def ssl_configured?
    false
  end

  def track_params
    {
      referer: request.referer,
      remote_ip: request.remote_ip,
      user_agent: request.user_agent,
      signature: params[:signature].to_s,
      url: params[:url].to_s
    }
  end

  def set_message
    @message = Message.find_by token: params[:id]
  end
end
