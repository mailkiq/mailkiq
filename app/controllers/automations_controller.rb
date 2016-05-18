class AutomationsController < ApplicationController
  before_action :authenticate_account!

  def index
    @automations = current_account.automations
  end

  def new
    @automation = current_account.automations.build
  end

  def create
    @automation = current_account.automations.create automation_params
    respond_with @automation, location: automations_path
  end

  def edit
    @automation = current_account.automations.find params[:id]
  end

  def update
    @automation = current_account.automations.find params[:id]
    @automation.update automation_params
    respond_with @automation, location: automations_path
  end

  def destroy
    @automation = current_account.automations.find params[:id]
    @automation.destroy
    respond_with @automation, location: automations_path
  end

  private

  def automation_params
    params.require(:automation).permit :name, :campaign_id
  end
end
