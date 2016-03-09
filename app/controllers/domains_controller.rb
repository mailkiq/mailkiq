class DomainsController < ApplicationController
  before_action :require_login

  def create
    @domain = current_user.domains.new domain_params
    @domain.save
    respond_with @domain, flash_now: false do |format|
      format.html { redirect_to amazon_settings_path }
    end
  end

  def destroy
    @domain = current_user.domains.find params[:id]
    @domain.destroy
    respond_with @domain, flash_now: false, location: amazon_settings_path
  end

  private

  def domain_params
    params.require(:domain).permit :name
  end
end
