class DeliveriesController < AdminController
  before_action :find_campaign

  def new
    @delivery = Delivery.new account: current_user
  end

  def create
    @deliver = Delivery.new deliver_params
    @deliver.campaign = @campaign
    @deliver.save
    respond_with @deliver, location: campaign_delivery_path(@campaign)
  end

  private

  def deliver_params
    params.require(:delivery).permit tagged_with: [], not_tagged_with: []
  end

  def find_campaign
    @campaign = current_user.campaigns.find params[:campaign_id]
  end
end
