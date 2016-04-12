require 'rails_helper'

describe MarketingController, type: :controller do
  describe '#index' do
    before { get :index }

    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :index }
    it { is_expected.to_not render_with_layout }
  end
end
