require 'rails_helper'

RSpec.describe Tagging, type: :model do
  it { is_expected.to belong_to :tag }
  it { is_expected.to belong_to :subscriber }
  it { is_expected.to have_db_index :tag_id }
  it { is_expected.to have_db_index :subscriber_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to_not have_db_column :updated_at }
end
