require 'rails_helper'

describe UnsubscribesController, type: :controller do
  describe 'GET /unsubscribe' do
    before do
      subscriber = Fabricate.build :subscriber, id: 1

      expect(subscriber).to receive(:unsubscribed!)
      expect(Subscriber).to receive(:find)
        .with(subscriber.id)
        .and_return(subscriber)

      get :show, token: subscriber.subscription_token
    end

    it { is_expected.to render_template :show }
    it { is_expected.to respond_with :success }
  end
end
