require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to belong_to :campaign }
end
