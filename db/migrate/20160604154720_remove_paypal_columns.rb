class RemovePaypalColumns < ActiveRecord::Migration
  def change
    remove_column :accounts, :paypal_customer_token, :string
    remove_column :accounts, :paypal_recurring_profile_token, :string
  end
end
