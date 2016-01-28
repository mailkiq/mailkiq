require 'rails_helper'

describe SubscribersController, type: :controller do
  let(:permitted_params) do
    %i(name email)
  end

  context 'when logged in' do
    before do
      @account = Fabricate.build(:account)
      sign_in_as @account
    end

    it_behaves_like 'a index request', path: '/subscribers' do
      before { allow(@account).to receive(:subscribers) }
    end

    it_behaves_like 'a new request', path: '/subscribers/new' do
      before { allow(@account).to receive_message_chain(:subscribers, :new) }
    end

    it_behaves_like 'a create request', path: '/subscribers' do
      let(:params) { Fabricate.attributes_for(:subscriber) }

      before do
        allow(@account).to receive_message_chain(:subscribers, :create).with(params)
      end
    end

    it_behaves_like 'an edit request', path: '/subscribers/:id/edit' do
      before do
        @subscriber = Fabricate.build :subscriber, id: 1

        allow(@account).to receive_message_chain(:subscribers, :find)
          .with(@subscriber.id.to_s)
          .and_return(@subscriber)
      end

      let(:params) do
        { id: @subscriber.id }
      end
    end

    it_behaves_like 'an update request', path: '/subscribers/:id' do
      before do
        @subscriber = Fabricate.build :subscriber, id: 1
        @attributes = Fabricate.attributes_for(:maria_doe)

        allow(@subscriber).to receive(:update).with(@attributes)
        allow(@account).to receive_message_chain(:subscribers, :find)
          .with(@subscriber.id.to_s)
          .and_return(@subscriber)
      end

      let(:params) do
        { id: @subscriber.id, subscriber: @attributes }
      end
    end

    it_behaves_like 'a destroy request', path: '/subscribers/:id' do
      before do
        @subscriber = Fabricate.build :subscriber, id: 1

        allow(@subscriber).to receive(:destroy)
        allow(@account).to receive_message_chain(:subscribers, :find)
          .with(@subscriber.id.to_s)
          .and_return(@subscriber)
      end

      let(:params) do
        { id: @subscriber.id }
      end
    end
  end
end
