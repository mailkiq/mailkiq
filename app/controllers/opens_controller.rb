class OpensController < ApplicationController
  PIXEL = 'R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='.freeze

  def show
    @message = Message.find_by token: params[:id]
    @message.see! request if @message && @message.unopened?
    send_data Base64.decode64(PIXEL), type: 'image/gif', disposition: :inline
  end
end
