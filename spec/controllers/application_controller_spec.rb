require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render nothing: true
    end
  end

  let(:account) { Fabricate.build :account }

  it { is_expected.to use_around_action :set_time_zone }
  it { is_expected.to use_before_action :set_raven_context }

  context 'when logged in' do
    describe '#set_time_zone' do
      it 'uses current user time zone' do
        sign_in account
        expect(Time).to receive(:use_zone).with account.time_zone
        get :index
      end
    end

    describe '#set_raven_context' do
      it 'provides additional context to Raven' do
        sign_in account

        expect(Raven).to receive(:user_context)
          .with account.slice(:id, :name, :email)

        get :index
      end
    end
  end
end
