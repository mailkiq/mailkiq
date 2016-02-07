require 'rails_helper'

describe CampaignMailer, type: :mailer do
  it { expect(described_class.delivery_methods).to include(ses: SES::Base) }

  describe '#campaign' do
    pending
  end
end
