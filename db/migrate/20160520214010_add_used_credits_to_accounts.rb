class AddUsedCreditsToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :used_credits, :integer, null: false, default: 0
  end
end
