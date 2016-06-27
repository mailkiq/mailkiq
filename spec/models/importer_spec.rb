require 'rails_helper'

describe Importer, type: :model do
  let(:account) { Fabricate.build :account }

  subject { described_class.new account }

  describe '#process!' do
    it 'inserts subscribers on the database' do
      subject.process! <<-CSV.strip_heredoc
        hermanmiller@gmail.com,Herman Miller
      CSV

      subscriber = account.subscribers.first!
      expect(subscriber.name).to eq('Herman Miller')
      expect(subscriber.email).to eq('hermanmiller@gmail.com')
      expect(subscriber).to be_active
    end
  end
end
