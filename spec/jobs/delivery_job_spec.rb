require 'rails_helper'

RSpec.describe DeliveryJob do
  let(:campaign) { Fabricate.build :campaign_with_account, state: :queued }

  subject { described_class.new args: [campaign.id] }

  describe '#run' do
    it 'pushes jobs to que_jobs table' do
      expect(Campaign).to receive_message_chain(:queued, :find)
        .with(campaign.id)
        .and_return(campaign)

      expect_any_instance_of(Delivery).to receive(:deliver!).and_yield
      expect(subject).to receive(:destroy).twice

      subject._run
    end
  end
end
