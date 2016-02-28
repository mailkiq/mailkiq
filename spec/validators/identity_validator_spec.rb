require 'rails_helper'

describe IdentityValidator, vcr: { cassette_name: :list_verified_email_addresses } do
  let(:account) { Fabricate.build :valid_account }
  let(:campaign) { Fabricate.build :campaign, account: account }

  describe '#validate_each' do
    it 'verify domain name record on the database' do
      msg = t('activerecord.errors.models.campaign.unverified_domain')

      expect(account).to receive(:domain_names).and_return(['google.com'])
      expect(campaign).to_not be_valid
      expect(campaign.errors[:from_email]).to include msg
    end

    it 'verify email address on Amazon SES' do
      msg = t('activerecord.errors.models.campaign.unverified_email_address')

      campaign.from_email = 'liza@thoughtplane.com'

      expect(account).to receive(:domain_names).and_return(['thoughtplane.com'])
      expect(campaign).not_to be_valid
      expect(campaign.errors[:from_email]).to include msg

      campaign.from_email = 'rainer@thoughtplane.com'

      expect(account).to receive(:domain_names).and_return(['thoughtplane.com'])
      expect(campaign).to be_valid
      expect(campaign.errors[:from_email]).to be_empty
    end
  end
end
