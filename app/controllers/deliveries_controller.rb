class DeliveriesController < ApplicationController
  before_action :authenticate_account!
  before_action :set_campaign

  def new
    @delivery = Delivery.new @campaign
  end

  def create
    @delivery = Delivery.new @campaign

    if @delivery.call campaign_params
      flash[:notice] = t('flash.deliveries.create.notice')
      redirect_to campaign_path(@campaign)
    else
      flash[:alert] = t('flash.deliveries.create.alert')
      render :new
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit tagged_with: [], not_tagged_with: []
  end

  def set_campaign
    @campaign = current_account.campaigns.unsent.find params[:campaign_id]
  end
end
