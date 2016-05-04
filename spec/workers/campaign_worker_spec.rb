require 'rails_helper'

describe CampaignWorker, type: :worker do
  it { is_expected.to save_backtrace }
  it { is_expected.to be_retryable 0 }

  describe '#perform' do
    it 'delivers campaign to the subscriber' do
      expect(ActiveRecord::Base).to receive(:transaction).and_yield
      expect(Email).to receive_message_chain :new, :deliver!
      subject.perform 1, 1
    end

    it 'changes state to unconfirmed when email address is invalid' do
      exception = Aws::SES::Errors::InvalidParameterValue.new nil, nil

      expect(ActiveRecord::Base).to receive(:transaction).and_raise exception
      expect(Raven).to receive(:capture_exception).with kind_of(exception.class)
      expect(Subscriber).to receive_message_chain(:where, :update_all)
        .with state: Subscriber.states[:unconfirmed]
      expect { subject.perform 1, 1 }.not_to raise_exception
    end

    it 'requeues job when rate exceeded' do
      exception = Aws::SES::Errors::Throttling.new nil, nil

      expect(ActiveRecord::Base).to receive(:transaction).and_raise exception
      expect(CampaignWorker).to receive(:perform_async).with 1, 1
      expect(Raven).to receive(:capture_exception)
        .with kind_of(exception.class)
      expect { subject.perform 1, 1 }.not_to raise_exception
    end
  end
end
