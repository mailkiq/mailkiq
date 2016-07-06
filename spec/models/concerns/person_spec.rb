require 'spec_helper'

RSpec.describe Person, type: :model do
  Human = Struct.new(:name) do
    include Person

    def name?
      name.present?
    end
  end

  subject { Human.new 'Jesus Christ' }

  describe '#first_name' do
    it { expect(subject.first_name).to eq('Jesus') }
  end

  describe '#last_name' do
    it { expect(subject.last_name).to eq('Christ') }
  end
end
