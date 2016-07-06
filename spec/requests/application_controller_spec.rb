require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  context 'when logged in' do
    let(:account) { Fabricate.build :account }

    before do
      https!
      stub_sign_in account
    end

    describe '#set_locale' do
      it 'sets locale option' do
        expect(I18n).to receive(:locale=).with(account.language)

        get '/'
      end
    end

    describe '#set_time_zone' do
      it 'uses current user time zone' do
        expect(Time).to receive(:use_zone).with account.time_zone

        get '/'
      end
    end

    describe '#set_raven_context' do
      it 'provides additional context to Appsignal' do
        expect(Appsignal).to receive(:tag_request)
          .with account.slice(:id, :name, :email)

        get '/'
      end
    end
  end
end
