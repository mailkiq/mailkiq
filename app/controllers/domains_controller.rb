class DomainsController < ApplicationController
  before_action :require_login

  def create
    @domain = current_user.domains.new domain_params
    @domain.save
    respond_with @domain, location: amazon_settings_path
  end

  def destroy
    @domain = current_user.domains.find params[:id]
    @domain.destroy
    respond_with @domain, location: amazon_settings_path
  end

  private

  def domain_params
    params.require(:domain).permit :name
  end
end
