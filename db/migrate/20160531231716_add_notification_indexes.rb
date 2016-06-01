class AddNotificationIndexes < ActiveRecord::Migration
  def change
    add_index :notifications, :message_id,
              name: 'index_bounced_notifications',
              where: "data ? 'bouncedRecipients'"

    add_index :notifications, :message_id,
              name: 'index_complained_notifications',
              where: "data ? 'complainedRecipients'"
  end
end
