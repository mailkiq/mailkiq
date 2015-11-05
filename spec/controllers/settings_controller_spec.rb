require 'rails_helper'

describe SettingsController, type: :controller do
  context 'when logged in', vcr: { cassette_name: :valid_credentials } do
    let(:jane_doe) { Fabricate.attributes_for(:jane_doe) }
    let(:current_user) { controller.current_user }
    let(:aws_params) { %i(aws_access_key_id aws_secret_access_key aws_region) }
    let(:profile_params) { %i(name email password language time_zone) }

    before do
      account = Fabricate.build(:account)

      allow_any_instance_of(Account).to receive(:update) do |record, params|
        record.assign_attributes(params)
        true
      end

      sign_in_as account
    end

    describe 'PUT /profile' do
      before { put :profile, account: jane_doe }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to set_flash.now[:notice] }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to permit_params(profile_params) }
      it { is_expected.not_to permit_params(aws_params) }
    end

    describe 'PUT /aws' do
      before { put :aws, account: jane_doe }

      it { is_expected.to use_before_action :require_login }
      it { is_expected.to respond_with :success }
      it { is_expected.to set_flash.now[:notice] }
      it { is_expected.to render_with_layout 'admin' }
      it { is_expected.to permit_params(aws_params) }
      it { is_expected.not_to permit_params(profile_params) }
    end

    def permit_params(params)
      options = { verb: :put, params: { account: jane_doe } }
      permit(*params).for(controller.action_name, options).on(:account)
    end
  end
end
