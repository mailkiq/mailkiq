class AddAutomationColumnsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :type, :string, default: '', null: false
    add_column :campaigns, :send_settings, :jsonb, null: false, default: {}
    add_column :campaigns, :trigger_settings, :jsonb, null: false, default: {}
    add_column :campaigns, :state, :integer

    say_with_time 'Updating campaigns state...' do
      Campaign.reset_column_information
      Campaign.update_all state: Campaign.states[:draft]
      Campaign.sent.update_all state: Campaign.states[:sent]
    end

    change_column_null :campaigns, :state, false
  end
end
