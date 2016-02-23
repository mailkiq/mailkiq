require 'spec_helper'

class Human
  include Person
  attr_accessor :name

  def name?
    name.present?
  end
end

describe Person, type: :model do
  subject do
    human = Human.new
    human.name = 'Jesus Christ'
    human
  end

  describe '#first_name' do
    it { expect(subject.first_name).to eq('Jesus') }
  end

  describe '#last_name' do
    it { expect(subject.last_name).to eq('Christ') }
  end
end
