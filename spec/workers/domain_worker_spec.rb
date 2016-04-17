require 'rails_helper'

describe DomainWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_processed_in :platform }

  describe '#perform' do
    it 'updates statuses attributes' do
      account = Fabricate.build :account
      expect(Account).to receive(:find).with(1).and_return(account)
      expect(account).to receive_message_chain(:domains, :each)
      subject.perform(1)
    end
  end
end
