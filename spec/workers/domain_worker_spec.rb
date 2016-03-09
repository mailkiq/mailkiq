require 'rails_helper'

describe DomainWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_processed_in :platform }

  it 'synchronize domain status' do
    account = Account.new

    expect(account).to receive_message_chain(:domains, :each)
    expect(Account).to receive(:find).with(1).and_return(account)

    subject.perform(1)
  end
end
