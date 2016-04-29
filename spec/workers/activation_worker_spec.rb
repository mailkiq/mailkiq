require 'rails_helper'

describe ActivationWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_processed_in :platform }

  describe '#perform' do
    it 'associates a new SNS topic on Amazon SES with specified account' do
      account = Fabricate.build :account

      expect(Account).to receive(:find).with(1)
        .at_least(:once)
        .and_return(account)

      expect_any_instance_of(AccountActivation).to receive(:activate)
      expect_any_instance_of(AccountActivation).to receive(:deactivate)

      subject.perform(1, :activate)
      subject.perform(1, :deactivate)
    end
  end
end
