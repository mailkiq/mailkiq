require 'rails_helper'

describe DomainValidator do
  let(:account) { Fabricate.build :valid_account }
  let(:campaign) { Fabricate.build :campaign, account: account }

  describe '#validate_each' do
    it 'verify domain name record on the database' do
      msg = t('activerecord.errors.models.campaign.unverified_domain')

      expect(account).to receive(:domain_names).and_return(['google.com'])
      expect(campaign).to_not be_valid
      expect(campaign.errors[:from_email]).to include msg
    end
  end
end
