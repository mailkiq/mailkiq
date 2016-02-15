require 'rails_helper'

describe Tagging, type: :model do
  it { is_expected.to belong_to :tag }
  it { is_expected.to belong_to :subscriber }
end
