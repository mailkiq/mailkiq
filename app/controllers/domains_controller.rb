class DomainsController < ApplicationController
  before_action :require_login

  def create
    @domain = current_user.domains.new domain_params
    @domain.transaction do
      @domain.status = Domain.statuses[:pending]
      @domain.verification_token = get_verification_token(@domain.name)
      @domain.save
    end

    respond_with @domain, flash_now: false do |format|
      format.html { redirect_to amazon_settings_path }
    end
  end

  def destroy
    @domain = current_user.domains.find params[:id]
    @domain.transaction do
      ses.delete_identity(@domain.name)
      @domain.destroy
    end

    respond_with @domain, flash_now: false, location: amazon_settings_path
  end

  private

  def domain_params
    params.require(:domain).permit :name
  end

  def get_verification_token(name)
    ses.verify_domain_identity(name).body['VerificationToken']
  end
end
