class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :type, null: false
      t.jsonb :data, null: false
      t.belongs_to :message, null: false, index: true, foreign_key: true
    end
  end
end
