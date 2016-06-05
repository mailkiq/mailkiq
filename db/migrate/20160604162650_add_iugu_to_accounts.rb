class AddIuguToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :iugu_subscription_id, :uuid
    add_column :accounts, :iugu_customer_id, :uuid
  end
end
