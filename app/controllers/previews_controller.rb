class PreviewsController < ApplicationController
  before_action :authenticate_account!

  def show
    @campaign = current_account.campaigns.find params[:campaign_id]
    render layout: false
  end

  def create
    @subscribers = current_account.subscribers.where(email: email_param)
    @subscribers.pluck(:id).each do |subscriber_id|
      CampaignJob.enqueue params[:campaign_id], subscriber_id
    end
    redirect_to new_campaign_delivery_path
  end

  private

  def email_param
    params.dig(:preview, :email).to_s.split(',')
  end
end
