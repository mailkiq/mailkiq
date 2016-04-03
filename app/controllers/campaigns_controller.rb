class CampaignsController < ApplicationController
  before_action :authenticate_account!
  before_action :find_campaign, except: [:index, :new, :create]

  has_scope :page, default: 1
  has_scope :sort

  def index
    @campaigns = apply_scopes current_account.campaigns
    @campaigns = @campaigns.recents unless current_scopes.key?(:sort)
  end

  def new
    @campaign = current_account.campaigns.new
  end

  def create
    @campaign = current_account.campaigns.create campaign_params
    respond_with @campaign, location: campaigns_path
  end

  def edit
  end

  def update
    @campaign.update campaign_params
    respond_with @campaign, location: campaigns_path
  end

  def destroy
    @campaign.destroy
    @campaign.queue.clear
    respond_with @campaign, location: campaigns_path
  end

  def preview
    render layout: false
  end

  def duplicate
    @new_campaign = @campaign.duplicate
    @new_campaign.save
    respond_with @new_campaign, flash_now: false do |format|
      format.html { redirect_to campaigns_path }
    end
  end

  private

  def find_campaign
    @campaign = current_account.campaigns.find params[:id]
  end

  def campaign_params
    params.require(:campaign).permit :name, :subject, :from_name, :from_email,
                                     :html_text, :plain_text
  end
end
