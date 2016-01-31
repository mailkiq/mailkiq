class CampaignsController < AdminController
  def index
    @campaigns = current_user.campaigns
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

  private

  def campaign_params
    params.require(:campaign).permit :name, :subject, :from_name, :from_email,
                                     :reply_to, :html_text
  end
end
