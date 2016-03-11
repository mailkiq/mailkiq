class OpensController < ApplicationController
  PIXEL = 'R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='.freeze

  def show
    @message = Message.find_by token: params[:id]

    if @message && !@message.opened_at
      @message.opened_at = Time.now
      @message.save!
    end

    send_data Base64.decode64(PIXEL), type: 'image/gif', disposition: :inline
  end
end
