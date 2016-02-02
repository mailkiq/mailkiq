require 'rails_helper'

describe Notification, type: :model do
  it { is_expected.to belong_to :account }
end
