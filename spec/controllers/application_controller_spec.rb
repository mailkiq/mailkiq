require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render nothing: true
    end
  end

  let(:account) { Fabricate.build :account }

  it { is_expected.to use_before_action :set_locale }
  it { is_expected.to use_before_action :set_raven_context }
  it { is_expected.to use_around_action :set_time_zone }

  context 'when logged in' do
    describe '#set_locale' do
      it 'sets locale option' do
        sign_in account
        expect(I18n).to receive(:locale=).with(account.language)
        get :index
      end
    end

    describe '#set_time_zone' do
      it 'uses current user time zone' do
        sign_in account
        expect(Time).to receive(:use_zone).with account.time_zone
        get :index
      end
    end

    describe '#set_raven_context' do
      it 'provides additional context to Appsignal' do
        sign_in account

        expect(Appsignal).to receive(:tag_request)
          .with account.slice(:id, :name, :email)

        get :index
      end
    end
  end
end
