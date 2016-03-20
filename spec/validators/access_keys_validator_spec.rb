require 'rails_helper'

describe AccessKeysValidator do
  vcr_options = { cassette_name: :invalid_client_token_id }

  context 'invalid credentials', vcr: vcr_options do
    it 'append error message to AWS Access key ID attribute' do
      account = Fabricate.build(:account)
      error_message = I18n.t('activerecord.errors.models.account.invalid_token')
      expect(account).not_to be_valid
      expect(account.errors.keys).to eq([:aws_access_key_id])
      expect(account.errors.messages[:aws_access_key_id])
        .to include(error_message)
    end
  end
end
