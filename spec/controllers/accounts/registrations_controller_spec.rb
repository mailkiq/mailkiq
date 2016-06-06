require 'rails_helper'

describe Accounts::RegistrationsController, type: :controller do
  let(:account) { Fabricate.build :account }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:account]
  end

  describe '#create' do
    let(:params) do
      { name: 'teste', email: 'teste@teste.com',
        password: 'testando', password_confirmation: 'testando' }
    end

    before do
      allow_any_instance_of(Billing).to receive(:process)
      allow_any_instance_of(Account).to receive(:save)
      allow_any_instance_of(Account).to receive(:persisted?).and_return(true)
      allow(ActivationJob).to receive(:enqueue).with(any_args, :activate)
      post :create, account: params
    end

    it { is_expected.to use_before_action :configure_permitted_parameters }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to root_path }
  end

  describe '#activate' do
    before do
      sign_in account

      expect_any_instance_of(Billing)
        .to receive_message_chain(:subscription, :activate)

      get :activate
    end

    it { is_expected.to use_before_action :set_billing }
    it { is_expected.to use_before_action :authenticate_scope! }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to edit_account_registration_path }
  end

  describe '#suspend' do
    before do
      sign_in account

      expect_any_instance_of(Billing)
        .to receive_message_chain(:subscription, :suspend)

      get :suspend
    end

    it { is_expected.to use_before_action :set_billing }
    it { is_expected.to use_before_action :authenticate_scope! }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to edit_account_registration_path }
  end
end
