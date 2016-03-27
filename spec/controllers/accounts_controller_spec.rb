require 'rails_helper'

describe AccountsController, type: :controller do
  describe 'GET /sign_up' do
    before { get :new, plan_id: 10 }

    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :new }

    it 'sets default attributes' do
      assigned_user = assigns(:user)
      expect(assigned_user.plan_id).to eq(10)
    end
  end

  describe 'POST /sign_up' do
    let(:account_params) do
      account_params = Fabricate.attributes_for(:valid_account)
      account_params[:password] = 'teste'
      account_params[:password_confirmation] = 'teste'
      account_params.with_indifferent_access
    end

    before do
      paypal = double

      allow(paypal).to receive(:checkout_url)
        .with(return_url: paypal_thank_you_url,
              cancel_url: paypal_canceled_url,
              ipn_url: paypal_ipn_url)
        .and_return('https://www.sandbox.paypal.com/')

      allow_any_instance_of(Account)
        .to receive(:paypal)
        .and_return(paypal)

      expect_any_instance_of(AccessKeysValidator)
        .not_to receive(:validate)
        .at_least(:once)

      post :create, account: account_params
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to set_session[:user_params] }
    it do
      is_expected
        .to permit(:name, :email, :plan_id, :password, :password_confirmation)
        .for(:create, params: { account: account_params })
        .on(:account)
    end

    it 'redirects to PayPal checkout page' do
      expect(response.location).to start_with('https://www.sandbox.paypal.com/')
    end

    it 'sets default attributes' do
      assigned_user = assigns(:user)
      expect(assigned_user.plan_id).to eq(account_params[:plan_id])
      expect(assigned_user.aws_access_key_id)
        .to eq(ENV['MAILKIQ_ACCESS_KEY_ID'])
      expect(assigned_user.aws_secret_access_key)
        .to eq(ENV['MAILKIQ_SECRET_ACCESS_KEY'])
    end
  end
end
