class AddCountersToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :recipients_count, :integer, null: false, default: 0
    add_column :campaigns, :unique_opens_count, :integer, null: false, default: 0
    add_column :campaigns, :unique_clicks_count, :integer, null: false, default: 0
  end
end
