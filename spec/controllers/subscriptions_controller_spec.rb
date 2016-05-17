require 'rails_helper'

describe SubscriptionsController, type: :controller do
  describe '#unsubscribe' do
    before do
      subscriber = Fabricate.build :subscriber, id: 1

      expect(subscriber).to receive(:unsubscribed!)
      expect(Subscriber).to receive(:find)
        .with(subscriber.id)
        .and_return(subscriber)

      get :unsubscribe, token: Token.encode(subscriber.id)
    end

    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :unsubscribe }
    it { is_expected.to_not render_with_layout }
  end
end
