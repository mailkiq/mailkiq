class CampaignsController < ApplicationController
  before_action :authenticate_account!

  has_scope :page, default: 1
  has_scope :sort, default: nil, allow_blank: true do |_, scope, value|
    value.blank? ? scope.recent : scope.sort(value)
  end

  def index
    @campaigns = apply_scopes current_account.campaigns
  end

  def show
    @campaign = current_account.campaigns.find params[:id]
    @metrics = MetricsPresenter.new @campaign, view_context
    page_meta[:name] = @campaign.name
  end

  def new
    @campaign = current_account.campaigns.new
  end

  def create
    @campaign = current_account.campaigns.create campaign_params
    respond_with @campaign, location: campaigns_path
  end

  def edit
    @campaign = current_account.campaigns.unsent.find params[:id]
  end

  def update
    @campaign = current_account.campaigns.unsent.find params[:id]
    @campaign.update campaign_params
    respond_with @campaign, location: campaigns_path
  end

  def destroy
    @campaign = current_account.campaigns.find params[:id]
    @campaign.destroy
    @queue = Sidekiq::Queue.new(@campaign.queue_name)
    @queue.clear
    respond_with @campaign, location: campaigns_path
  end

  def preview
    @campaign = current_account.campaigns.find params[:id]
    render layout: false
  end

  def duplicate
    @campaign = current_account.campaigns.find params[:id]
    @new_campaign = @campaign.duplicate
    @new_campaign.save
    respond_with @new_campaign, flash_now: false do |format|
      format.html { redirect_to campaigns_path }
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit :name, :subject, :from_name, :from_email,
                                     :html_text, :plain_text
  end
end
