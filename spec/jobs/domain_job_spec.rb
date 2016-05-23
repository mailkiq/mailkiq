require 'rails_helper'

describe DomainJob do
  describe '#run' do
    it 'updates statuses attributes' do
      account = Fabricate.build :account
      expect(Account).to receive(:find).with(1).and_return(account)
      expect(account).to receive_message_chain(:domains, :each)
      described_class.new(args: [1])._run
    end
  end
end
