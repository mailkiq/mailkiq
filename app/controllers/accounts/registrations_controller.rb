module Accounts
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
    before_action :set_billing, only: [:edit, :update]
    layout :pick_layout

    def create
      super do |resource|
        ActivationJob.enqueue resource.id, :activate

        billing = Billing.new(resource)
        billing.process
      end
    end

    protected

    def set_billing
      billing = Billing.new(resource)
      @subscription = billing.subscription
      @invoices = billing.invoices
    end

    def after_update_path_for(_resource)
      edit_account_registration_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |account_params|
        account_params.permit :name, :email, :password, :password_confirmation,
                              :credit_card_token, :plan
      end

      devise_parameter_sanitizer.permit(:account_update) do |account_params|
        account_params.permit :name, :email, :time_zone, :language,
                              :current_password, :password,
                              :password_confirmation
      end
    end

    def update_resource(resource, params)
      if params.key? :password
        resource.force_password_validation = true
        super
      else
        resource.update_without_password(params)
      end
    end

    def pick_layout
      account_signed_in? ? 'application' : 'devise'
    end
  end
end
