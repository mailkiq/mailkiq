require 'rails_helper'

describe Plan, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to have_many :accounts }
end
