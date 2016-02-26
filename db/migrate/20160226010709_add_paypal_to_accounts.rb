class AddPaypalToAccounts < ActiveRecord::Migration
  def change
    add_belongs_to :accounts, :plan
    add_column :accounts, :paypal_customer_token, :string
    add_column :accounts, :paypal_recurring_profile_token, :string
  end
end
