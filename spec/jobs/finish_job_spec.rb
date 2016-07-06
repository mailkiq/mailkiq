require 'rails_helper'

RSpec.describe FinishJob do
  subject { described_class.new args: [1] }

  describe '#run' do
    it 'changes state of campaign to sent' do
      campaign = Fabricate.build :campaign

      expect(Campaign).to receive_message_chain(:sending, :find).with(1)
        .and_return(campaign)
      expect(campaign).to receive(:finish!).and_yield
      expect(subject).to receive(:destroy).twice

      subject._run
    end
  end
end
