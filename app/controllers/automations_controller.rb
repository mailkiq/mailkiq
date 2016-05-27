class AutomationsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_automation, except: [:index, :new, :create]

  has_scope :page, default: 1
  has_scope :sort, default: nil, allow_blank: true do |_, scope, value|
    value.blank? ? scope.recent : scope.sort(value)
  end

  def index
    @automations = apply_scopes current_account.automations
  end

  def new
    @automation = current_account.automations.build
  end

  def create
    @automation = current_account.automations.build automation_params
    @automation.save
    respond_with @automation, location: automations_path
  end

  def edit
  end

  def update
    @automation.update automation_params
    respond_with @automation, location: automations_path
  end

  def destroy
    @automation.destroy
    respond_with @automation, location: automations_path
  end

  def pause
    @automation.paused!
    respond_with @automation, location: automations_path
  end

  def resume
    @automation.sending!
    respond_with @automation, location: automations_path
  end

  private

  def set_automation
    @automation = current_account.automations.find params[:id]
  end

  def automation_params
    params.require(:automation).permit :name, :subject, :from_name, :from_email,
                                       :html_text, :plain_text, :send_type
  end
end
