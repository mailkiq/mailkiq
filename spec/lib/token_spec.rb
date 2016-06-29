require 'spec_helper'
require 'token'

describe Token do
  let(:encoded_token) do
    'BAh7BjoMdXNlcl9pZGkG--11a84292bed52f308c004e62e9567928075fe56c'
  end

  describe '.secret_key_base' do
    it 'alias to secret_key_base option' do
      expect(described_class.secret_key_base)
        .to eq(Rails.application.secrets.secret_key_base)
    end
  end

  describe '.encode' do
    it 'encode given value' do
      expect(described_class.encode(user_id: 1)).to eq(encoded_token)
    end
  end

  describe '.decode' do
    it 'decode given value' do
      expect(described_class.decode(encoded_token)).to eq(user_id: 1)
    end
  end
end
