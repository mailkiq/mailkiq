require 'rails_helper'

describe CampaignWorker, type: :worker do
  it { is_expected.to save_backtrace }

  it 'delivers campaign' do
    expect(CampaignMailer).to receive_message_chain(:campaign, :deliver_now)
    subject.perform(1, 1)
  end
end