class MoveTypeColumnToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :state, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE messages SET state = COALESCE((
            SELECT state + 1 FROM notifications WHERE message_id = messages.id
            ORDER BY id DESC LIMIT 1
          ), 0)
        SQL
      end

      dir.down do
        execute <<-SQL
          UPDATE notifications SET state = COALESCE((
            SELECT state - 1 FROM messages WHERE id = notifications.message_id
          ), 2)
        SQL
      end
    end

    remove_column :notifications, :type, :integer
  end
end
