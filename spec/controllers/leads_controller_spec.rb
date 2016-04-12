require 'rails_helper'

describe LeadsController, type: :controller do
  describe '#create' do
    before do
      account = Fabricate.build :account

      expect_any_instance_of(Subscriber).to receive(:save)

      expect(Account).to receive(:find_by)
        .with(email: 'rainerborene@gmail.com')
        .and_return(account)

      post :create, lead: { email: 'maria@doe.com' }
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to root_path }
    it { is_expected.to set_flash[:notice] }

    it 'sets subscriber attributes' do
      subscriber = assigns(:subscriber)
      expect(subscriber).to be_active
      expect(subscriber.name).to eq('maria')
    end
  end
end
