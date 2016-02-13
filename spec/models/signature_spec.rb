require 'rails_helper'

describe Signature, type: :model do
  describe '.secret_key_base' do
    it 'alias to secret_key_base option' do
      expect(described_class.secret_key_base)
        .to eq(Rails.application.secrets.secret_key_base)
    end
  end

  describe '.hexdigest' do
    it 'generate digest of given string' do
      signature = described_class.hexdigest('http://www.google.com.br')
      expect(signature).to eq('864e0b12940139fd4bc515696b8323df3c266eb0')
    end
  end

  describe '.secure_compare' do
    it 'compare both values' do
      signature = '864e0b12940139fd4bc515696b8323df3c266eb0'
      invalid = '864r0o12940139sq4op515696o8323qs3p266ro0'
      expect(described_class.secure_compare(signature, signature)).to be_truthy
      expect(described_class.secure_compare(signature, invalid)).to be_falsey
    end
  end
end
