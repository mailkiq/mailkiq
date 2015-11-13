require 'rails_helper'

describe Import, type: :model do
  let(:unknown_headers) do
    <<-CSV.gsub(/^\s+/, '')
      Name,Emailss
      jonh,john
    CSV
  end

  let(:invalid_emails) do
    <<-CSV.gsub(/^\s+/, '')
      Name,Email
      jonh,john@z
      mary,mary.com
    CSV
  end

  let(:list) do
    instance_double('List', custom_fields: [])
  end

  describe '#process' do
    it 'identify unknown columns' do
      importer = described_class.new text: unknown_headers, list: list
      importer.process
      expect(importer.errors.full_messages.to_s).to include('invalid')
    end

    it 'validate email address' do
      importer = described_class.new text: invalid_emails, list: list
      importer.process
      expect(importer.errors.full_messages.to_s).to include('email')
    end
  end
end
