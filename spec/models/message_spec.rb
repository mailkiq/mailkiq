require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to belong_to :campaign }
  it { is_expected.to have_many(:notifications).dependent :delete_all }
end
