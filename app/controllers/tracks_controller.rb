class TracksController < ApplicationController
  before_action :set_message

  def open
    @message_event = MessageEvent.new @message, request
    @message_event.open!
    send_data DECODED_PIXEL, type: 'image/gif', disposition: :inline
  end

  def click
    @message_event = MessageEvent.new @message, request
    @message_event.click!
    redirect_to @message_event.redirect_url
  end

  private

  def set_message
    @message = Message.find_by token: params[:id]
  end
end
