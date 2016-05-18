require 'rails_helper'

describe LeadsController, type: :controller do
  describe '#create' do
    let(:account) { Fabricate.build :account }
    let(:params) do
      { lead: { email: 'maria@doe.com', state: 'active' } }
    end

    before do
      allow_any_instance_of(Subscriber).to receive(:save) do |model|
        model.run_callbacks :create
      end

      expect(Account).to receive(:find_by)
        .with(email: 'rainerborene@gmail.com')
        .at_least(:once)
        .and_return(account)

      post :create, params
    end

    it { is_expected.to use_before_action :set_account }
    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to root_path }
    it { is_expected.to set_flash[:notice] }
    it { is_expected.to permit(:email).for(:create, params: params).on(:lead) }

    it 'sets subscriber attributes' do
      subscriber = assigns(:subscriber)
      subscriber.run_callbacks :create
      expect(subscriber).to be_unconfirmed
      expect(subscriber.name).to be_nil
      expect(subscriber.account).to eq(account)
    end
  end
end
