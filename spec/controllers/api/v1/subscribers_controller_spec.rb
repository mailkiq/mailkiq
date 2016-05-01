require 'rails_helper'

describe API::V1::SubscribersController, type: :controller do
  context 'when logged in' do
    describe '#create' do
      let(:account) { Fabricate.build :valid_account, id: 10 }
      let(:params) do
        {
          api_key: account.api_key,
          data: {
            type: 'subscribers',
            attributes: {
              name: 'Jonh Doe',
              email: 'jonh@doe.com',
              tags: ['teste']
            }
          }
        }
      end

      before do
        relation = double

        expect(relation).to receive(:pluck).with(:id).and_return([])
        expect(Tag).to receive(:where).with(name: ['teste'], account_id: 10)
          .and_return(relation)

        allow(ActiveRecord::Base).to receive(:transaction).and_yield
        expect_any_instance_of(Subscriber).to receive(:valid?).and_return(true)
        expect_any_instance_of(Subscriber).to receive(:save) do |resource|
          resource
        end

        expect_sign_in_as account
      end

      describe 'json response' do
        before { post :create, params }

        it { is_expected.to use_before_action :authenticate! }
        it { is_expected.to respond_with :created }
        it { expect(response.content_type).to eq Mime::JSON }
      end

      describe 'redirection' do
        before { post :create, params.merge(redirect_to: 'http://google.com') }

        it { is_expected.to use_before_action :authenticate! }
        it { is_expected.to respond_with :redirect }
        it { is_expected.to redirect_to 'http://google.com' }
      end
    end
  end
end
