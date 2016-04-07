class DeliveriesController < ApplicationController
  before_action :authenticate_account!
  before_action :find_campaign

  def new
    @delivery = Delivery.new campaign: @campaign
  end

  def create
    @delivery = Delivery.new deliver_params
    @delivery.campaign = @campaign
    @delivery.save
    respond_with @delivery, location: campaign_path(@campaign)
  end

  private

  def deliver_params
    params.require(:delivery).permit tagged_with: [], not_tagged_with: []
  end

  def find_campaign
    @campaign = current_account.campaigns.find params[:campaign_id]
  end
end
