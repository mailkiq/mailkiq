require 'rails_helper'

describe SubscriptionsController, type: :controller do
  let(:subscriber) { Fabricate.build :subscriber, id: 1 }
  let(:token) { Token.encode subscriber.id }

  describe '#show' do
    before do
      mock!
      get :show, id: token
    end

    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :show }
    it { is_expected.to_not render_with_layout }
  end

  describe '#subscribe' do
    before do
      mock!
      expect(subscriber).to receive(:subscribe!)
      get :subscribe, id: token
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to subscription_path(token) }
  end

  describe '#unsubscribe' do
    before do
      mock!
      expect(subscriber).to receive(:unsubscribe!)
      get :unsubscribe, id: token
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to subscription_path(token) }
  end

  def mock!
    expect(Subscriber).to receive(:find).with(subscriber.id)
      .and_return(subscriber)
  end
end
