class AddSentAtToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :sent_at, :datetime
  end
end
