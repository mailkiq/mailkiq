class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :type, null: false
      t.string :message_uid, null: false, index: true
      t.jsonb :data, null: false
    end
  end
end
