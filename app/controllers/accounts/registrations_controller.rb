module Accounts
  class RegistrationsController < Devise::RegistrationsController
    before_action :authenticate_scope!, only: [:edit, :update, :destroy,
                                               :activate, :suspend]
    before_action :configure_permitted_parameters
    before_action :set_billing, except: [:create]
    layout :pick_layout

    def create
      super do |resource|
        @billing = Billing.new(resource)
        @billing.process

        ActivationJob.enqueue resource.id, :activate if resource.persisted?

        if resource.errors.include? :base
          flash[:alert] = resource.errors.full_messages_for(:base).join
        end
      end
    end

    def update
      super do
        @billing.process
      end
    end

    def activate
      @billing.subscription.activate
      redirect_to edit_account_registration_path
    end

    def suspend
      @billing.subscription.suspend
      redirect_to edit_account_registration_path
    end

    protected

    def set_billing
      @billing = Billing.new(resource)
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
        account_params.permit :name, :email, :current_password, :password,
                              :password_confirmation, :credit_card_token, :plan
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
