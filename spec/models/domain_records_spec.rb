require 'rails_helper'

describe DomainRecords, type: :model do
  let(:domain) { Fabricate.build :domain }

  subject { described_class.new domain }

  describe '#txt_name' do
    it 'returns TXT name' do
      expect(subject.txt_name).to eq('_amazonses.example.com')
    end
  end

  describe '#txt_value' do
    it 'returns TXT value' do
      expect(subject.txt_value).to eq(domain.verification_token)
    end
  end

  describe '#mx_name' do
    it 'returns MX record name' do
      expect(subject.mx_name).to eq('bounce.example.com')
    end
  end

  describe '#mx_value' do
    it 'returns MX record value' do
      expect(subject.mx_value).to eq('feedback-smtp.us-east-1.amazonses.com')
    end
  end

  describe '#spf_name' do
    it 'returns SPF record name' do
      expect(subject.spf_name).to eq('bounce.example.com')
    end
  end

  describe '#spf_value' do
    it 'returns SPF record value' do
      expect(subject.spf_value).to eq('v=spf1 include:amazonses.com ~all')
    end
  end

  describe '#cnames' do
    it 'returns DKIM CNAME records' do
      record = subject.cnames.first
      expect(record.name).to eq('a._domainkey.example.com')
      expect(record.value).to eq('a.dkim.amazonses.com')
    end
  end
end
