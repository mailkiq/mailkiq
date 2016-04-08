class OpensController < ApplicationController
  PIXEL = 'R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='.freeze

  def show
    @message = Message.find_by token: params[:id]

    if @message && @message.unopened?
      @message.see! request
      Campaign.increment_counter :unique_opens_count, @message.campaign_id
    end

    send_data Base64.decode64(PIXEL), type: 'image/gif', disposition: :inline
  end
end
