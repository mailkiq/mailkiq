require 'rails_helper'

describe DeliveryJob do
  let(:campaign) { Fabricate.build :campaign_with_account }

  subject { described_class.new args: [campaign.id, nil, nil] }

  describe '#run' do
    it 'pushes jobs to que_jobs table' do
      expect(campaign).to receive(:with_lock).and_yield
      expect(Campaign).to receive_message_chain(:unsent, :find)
        .with(campaign.id)
        .and_return(campaign)

      expect(QueJob).to receive(:push_bulk)

      subject._run
    end
  end
end
