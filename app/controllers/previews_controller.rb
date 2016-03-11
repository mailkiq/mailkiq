class PreviewsController < ApplicationController
  before_action :require_login

  def show
    @campaign = current_user.campaigns.find params[:campaign_id]
    render layout: false
  end
end
