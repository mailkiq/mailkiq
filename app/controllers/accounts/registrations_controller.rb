module Accounts
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters
    layout :pick_layout

    def create
      build_resource(sign_up_params)

      if resource.valid? && !resource.paypal?
        session[:account_data] = params[:account]
        return redirect_to resource.paypal.checkout_url(
          return_url: new_account_registration_url(plan_id: params[:plan_id]),
          cancel_url: paypal_canceled_url,
          ipn_url: paypal_ipn_url
        )
      elsif resource.valid?
        session[:account_data] = nil
        resource.paypal.save!
      end

      if resource.persisted?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      end
    end

    protected

    def build_resource(hash=nil)
      super.tap do |account|
        data = (session[:account_data] || {}).reject { |_, v| v.blank? }
        secrets = Rails.application.secrets

        payment_token = data[:paypal_payment_token]
        payment_token ||= params.dig :account, :paypal_payment_token
        payment_token ||= params[:token]

        customer_token = data[:paypal_customer_token]
        customer_token ||= params.dig :account, :paypal_customer_token
        customer_token ||= params[:PayerID]

        account.name ||= data[:name]
        account.email ||= data[:email]
        account.plan_id ||= data.fetch :plan_id, params[:plan_id]
        account.password ||= data[:password]
        account.password_confirmation ||= data[:password_confirmation]
        account.paypal_payment_token = payment_token
        account.paypal_customer_token = customer_token
        account.aws_access_key_id = secrets[:aws_access_key_id]
        account.aws_secret_access_key = secrets[:aws_secret_access_key]
      end
    end

    def after_update_path_for(_resource)
      edit_account_registration_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit :name, :email, :plan_id, :password, :password_confirmation,
                 :paypal_customer_token, :paypal_payment_token
      end

      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit :name, :email, :time_zone, :language, :current_password,
                 :password, :password_confirmation
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
