class CampaignsController < ApplicationController
  before_action :require_login
  layout 'admin'

  def index
    @campaigns = current_user.campaigns
  end

  def new
    @campaign = current_user.campaigns.new
  end

  def create
    @campaign = current_user.campaigns.new campaign_params
    if @campaign.save
      redirect_to campaigns_path
    else
      render action: :new
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit :name, :subject, :from_name, :from_email,
                                     :reply_to, :html_text
  end
end
