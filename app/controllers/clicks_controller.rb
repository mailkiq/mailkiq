class ClicksController < ApplicationController
  def show
    @message = Message.find_by token: params[:id]
    @message.click! request if @message && @message.unclicked?

    url = params[:url].to_s
    signature = Signature.hexdigest(url)

    if Signature.secure_compare(params[:signature], signature)
      redirect_to url
    else
      redirect_to root_url
    end
  end
end
