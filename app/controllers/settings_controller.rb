class SettingsController < ApplicationController
  before_action :require_login
  layout 'admin'

  def profile
    if request.put?
      current_user.update profile_params
      respond_with current_user, flash_now: true
    end
  end

  def aws
    if request.put?
      current_user.update aws_params
      respond_with current_user, flash_now: true
    end
  end

  private

  def profile_params
    params.require(:account).permit :name, :email, :password, :language, :time_zone
  end

  def aws_params
    params.require(:account).permit :aws_access_key_id, :aws_secret_access_key, :aws_region
  end
end
