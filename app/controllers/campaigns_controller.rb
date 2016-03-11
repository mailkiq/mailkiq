class CampaignsController < ApplicationController
  before_action :require_login
  has_scope :page, default: 1
  has_scope :sort, using: [:column, :direction]

  def index
    @campaigns = apply_scopes current_user.campaigns
    @campaigns = @campaigns.recents unless current_scopes.key?(:sort)
  end

  def new
    @campaign = current_user.campaigns.new
  end

  def create
    @campaign = current_user.campaigns.create campaign_params
    respond_with @campaign, location: campaigns_path
  end

  def edit
    @campaign = current_user.campaigns.find params[:id]
  end

  def update
    @campaign = current_user.campaigns.find params[:id]
    @campaign.update campaign_params
    respond_with @campaign, location: campaigns_path
  end

  def destroy
    @campaign = current_user.campaigns.find params[:id]
    @campaign.destroy
    Sidekiq::Queue.new(@campaign.queue_name).clear
    respond_with @campaign, location: campaigns_path
  end

  private

  def campaign_params
    params.require(:campaign).permit :name, :subject, :from_name, :from_email,
                                     :html_text, :plain_text
  end
end
