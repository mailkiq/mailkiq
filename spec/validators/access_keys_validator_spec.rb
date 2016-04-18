require 'rails_helper'

describe AccessKeysValidator do
  describe '#validate' do
    it 'appends error message to AWS Access Key ID attribute' do
      account = Fabricate.build(:valid_account)
      message = I18n.t('activerecord.errors.models.account.invalid_token')

      expect_any_instance_of(Aws::SES::Client).to receive(:get_send_quota)
        .and_raise Aws::SES::Errors::InvalidClientTokenId.new('boom', 'boom')

      expect(account).not_to be_valid
      expect(account.errors.keys).to eq([:aws_access_key_id])
      expect(account.errors.messages[:aws_access_key_id]).to include(message)
    end
  end
end
