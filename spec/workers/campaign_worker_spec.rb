require 'rails_helper'

describe CampaignWorker do
  describe '#perform' do
    it 'delivers campaign to the subscriber' do
      expect(ActiveRecord::Base).to receive(:transaction).and_yield
      expect(CampaignMailer).to receive_message_chain(:campaign, :deliver_now)
      described_class.perform(1, 1)
    end

    it 'changes state to unconfirmed when email address is invalid' do
      expect(ActiveRecord::Base).to receive(:transaction)
        .and_raise Aws::SES::Errors::InvalidParameterValue.new(nil, nil)

      expect(Raven).to receive(:capture_exception)
      expect(Subscriber).to receive_message_chain(:where, :update_all)
        .with(state: Subscriber.states[:unconfirmed])

      expect { described_class.perform 1, 1 }.not_to raise_exception
    end
  end
end
