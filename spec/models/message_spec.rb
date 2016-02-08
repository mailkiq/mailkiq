require 'rails_helper'

describe Message, type: :model do
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to belong_to :campaign }
  it do
    is_expected.to have_many(:notifications)
      .with_primary_key(:uid)
      .with_foreign_key(:message_uid)
      .dependent(:delete_all)
  end
end
