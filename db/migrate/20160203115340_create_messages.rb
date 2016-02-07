class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :token
      t.string :message_id

      # user
      t.text :to, null: false
      t.belongs_to :subscriber, null: false, index: true, foreign_key: true

      # campaign
      t.belongs_to :campaign, null: false, index: true, foreign_key: true

      # timestamps
      t.timestamp :sent_at
      t.timestamp :opened_at
      t.timestamp :clicked_at

      # indexes
      t.index :token
      t.index :message_id
    end
  end
end
