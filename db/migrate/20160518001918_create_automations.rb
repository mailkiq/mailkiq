class CreateAutomations < ActiveRecord::Migration
  def change
    create_table :automations do |t|
      t.citext :name, null: false
      t.jsonb :conditions, null: false, default: {}
      t.belongs_to :account, null: false, index: true
      t.belongs_to :campaign, null: false, index: true
      t.foreign_key :accounts, on_deletee: :cascade
      t.foreign_key :campaigns, on_delete: :cascade
      t.index :name, unique: true
      t.timestamps null: false
    end
  end
end
