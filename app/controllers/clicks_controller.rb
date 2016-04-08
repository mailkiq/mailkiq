class ClicksController < ApplicationController
  def show
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
