class SettingsController < ApplicationController
  before_action :authenticate_account!

  def domains
    DomainWorker.perform_async current_account.id

    if request.put?
      current_account.update account_params
      respond_with current_account, flash_now: true
    end
  end

  private

  def account_params
    params.require(:account).permit :aws_access_key_id, :aws_secret_access_key,
                                    :aws_region
  end
end
