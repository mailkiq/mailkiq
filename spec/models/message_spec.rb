require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to belong_to :campaign }
  it { is_expected.to have_many :notifications }
  it do
    is_expected.to define_enum_for(:state)
      .with([:pending, :bounce, :complaint, :delivery])
  end
end
