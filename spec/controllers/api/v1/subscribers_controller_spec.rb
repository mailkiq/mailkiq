require 'rails_helper'

describe API::V1::SubscribersController, type: :controller do
  describe 'POST /api/v1/subscribers', :api do
    let(:account) { Fabricate.build :valid_account }

    before do
      set_content_type_header!
      api_sign_in account

      expect_any_instance_of(Subscriber)
        .to receive_message_chain(:account, :tags, :where, :pluck)
        .and_return([])

      expect_any_instance_of(Subscriber).to receive(:valid?).and_return(true)
      expect_any_instance_of(Subscriber).to receive(:save) do |resource|
        resource
      end

      post :create, api_key: account.api_key, data: {
        type: 'subscribers',
        attributes: {
          name: 'Jonh Doe',
          email: 'jonh@doe.com',
          tags: ['teste']
        }
      }
    end

    it { is_expected.to use_before_action :authenticate! }
    it { is_expected.to respond_with :created }
    it { expect(response.content_type).to eq Mime::JSON }
  end
end
