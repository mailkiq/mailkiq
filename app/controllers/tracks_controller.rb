class TracksController < ApplicationController
  PIXEL = 'R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=='.freeze

  def open
    @message = Message.find_by token: params[:id]

    if @message && @message.unopened?
      @message.see! request
      Campaign.increment_counter :unique_opens_count, @message.campaign_id
    end

    send_data Base64.decode64(PIXEL), type: 'image/gif', disposition: :inline
  end

  def click
    @message = Message.find_by token: params[:id]

    if @message && @message.unclicked?
      @message.click! request
      Campaign.increment_counter :unique_clicks_count, @message.campaign_id
    end

    url = params[:url].to_s
    signature = Signature.hexdigest(url)

    if Signature.secure_compare(params[:signature], signature)
      redirect_to url
    else
      redirect_to root_url
    end
  end
end
