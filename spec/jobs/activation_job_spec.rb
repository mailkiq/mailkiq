require 'rails_helper'

describe ActivationJob do
  describe '#run' do
    it 'associates a new SNS topic on Amazon SES with specified account' do
      account = Fabricate.build :account

      expect(Account).to receive(:find).with(1).twice.and_return(account)
      expect_any_instance_of(AccountActivation).to receive(:activate)
      expect_any_instance_of(AccountActivation).to receive(:deactivate)

      described_class.new(args: [1, :activate])._run
      described_class.new(args: [1, :deactivate])._run
    end
  end
end
