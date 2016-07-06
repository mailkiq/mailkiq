class PreviewsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_campaign

  def show
    render layout: false
  end

  def create
    @subscribers = current_account.subscribers.where(email: email_param)
    @subscribers.pluck(:id).each do |subscriber_id|
      CampaignJob.enqueue @campaign.id, subscriber_id
    end
    redirect_to new_campaign_delivery_path
  end

  private

  def set_campaign
    @campaign = current_account.campaigns.find params[:campaign_id]
  end

  def email_param
    params.dig(:preview, :email).to_s.split(',')
  end
end
