class SettingsController < ApplicationController
  before_action :authenticate_account!

  def edit
    DomainJob.enqueue current_account.id
  end

  def update
    current_account.update account_params
    respond_with current_account, location: edit_settings_path
  end

  private

  def account_params
    params.require(:account).permit :aws_access_key_id, :aws_secret_access_key,
                                    :aws_region
  end
end
