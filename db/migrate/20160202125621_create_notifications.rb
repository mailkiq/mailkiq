class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.jsonb :message, null: false
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
