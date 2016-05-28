class AddUnsubscribedAtToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :unsubscribed_at, :datetime
  end
end
