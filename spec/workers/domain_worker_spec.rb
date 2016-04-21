require 'rails_helper'

describe DomainWorker do
  describe '#perform' do
    it 'updates statuses attributes' do
      account = Fabricate.build :account
      expect(Account).to receive(:find).with(1).and_return(account)
      expect(account).to receive_message_chain(:domains, :each)
      described_class.perform(1)
    end
  end
end
