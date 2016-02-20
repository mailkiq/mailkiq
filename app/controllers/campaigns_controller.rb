class CampaignsController < AdminController
  def index
    @campaigns = current_user.campaigns.recents
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
    respond_with @campaign, location: campaigns_path
  end

  def preview
    @campaign = current_user.campaigns.find params[:id]
    render layout: false
  end

  private

  def campaign_params
    params.require(:campaign).permit :name, :subject, :from_name, :from_email,
                                     :reply_to, :html_text, :plain_text
  end
end
