require 'rails_helper'

describe TopicWorker do
  describe '#perform' do
    it 'associates a new SNS topic on Amazon SES with specified account' do
      account = Fabricate.build :account
      expect(Account).to receive(:find).with(1).and_return(account)
      expect_any_instance_of(AccountTopic).to receive(:up)
      described_class.perform(1, :up)
    end
  end
end
