require 'rails_helper'

describe DomainsController, type: :controller do
  context 'when logged in' do
    let(:account) { Fabricate.build :valid_account }

    before do
      sign_in_as account
    end

    describe 'POST /domains' do
      before do
        expect_any_instance_of(Domain).to receive(:identity_verify!)
        post :create, domain: { name: 'example.com' }
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to domains_settings_path }
      it { is_expected.to set_flash[:notice] }
    end

    describe 'DELETE /domains/:id' do
      before do
        domain = Domain.new name: 'example.com', account: account

        expect(domain).to receive(:identity_delete!)
        expect(account).to receive_message_chain(:domains, :find)
          .and_return(domain)

        delete :destroy, id: 1
      end

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to domains_settings_path }
      it { is_expected.to set_flash[:notice] }
    end
  end
end
