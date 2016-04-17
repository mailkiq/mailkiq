require 'rails_helper'

describe LeadsController, type: :controller do
  describe '#create' do
    let(:account) { Fabricate.build :account }
    let(:params) do
      { lead: { email: 'maria@doe.com' } }
    end

    before do
      allow_any_instance_of(Subscriber).to receive(:save)

      expect(Account).to receive(:find_by)
        .with(email: 'rainerborene@gmail.com')
        .at_least(:once)
        .and_return(account)

      post :create, params
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to root_path }
    it { is_expected.to set_flash[:notice] }
    it { is_expected.to permit(:email).for(:create, params: params).on(:lead) }

    it 'sets subscriber attributes' do
      subscriber = assigns(:subscriber)
      expect(subscriber).to be_active
      expect(subscriber.name).to eq('maria')
      expect(subscriber.account).to eq(account)
    end
  end
end
