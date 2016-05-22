require 'rails_helper'

describe Notification, type: :model do
  it { is_expected.to have_db_column(:data).of_type :jsonb }
  it { is_expected.to belong_to :message }
end
