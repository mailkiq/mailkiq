require 'rails_helper'

describe Person, type: :model do
  describe '#first_name' do
    it 'return first name' do
      subscriber = Fabricate.build(:subscriber)
      expect(subscriber.first_name).to eq('Rainer')
    end
  end

  describe '#last_name' do
    it 'return last name' do
      subscriber = Fabricate.build(:subscriber)
      expect(subscriber.last_name).to eq('Borene')
    end
  end
end
