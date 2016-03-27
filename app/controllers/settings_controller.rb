class SettingsController < ApplicationController
  before_action :require_login

  def account
    update account_params if request.put?
  end

  def domains
    DomainWorker.perform_async current_user.id
    update domains_params if request.put?
  end

  private

  def update(account_params)
    current_user.update account_params
    respond_with current_user, flash_now: true
  end

  def account_params
    params.require(:account).permit :name, :email, :time_zone,
                                    :current_password, :password,
                                    :password_confirmation
  end

  def domains_params
    params.require(:account).permit :aws_access_key_id, :aws_secret_access_key,
                                    :aws_region
  end
end
