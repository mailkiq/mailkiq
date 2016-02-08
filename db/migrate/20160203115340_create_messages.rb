class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :uid
      t.string :token

      # user
      t.belongs_to :subscriber, null: false, index: true, foreign_key: true

      # campaign
      t.belongs_to :campaign, null: false, index: true, foreign_key: true

      # timestamps
      t.timestamp :sent_at
      t.timestamp :opened_at
      t.timestamp :clicked_at

      # indexes
      t.index :uid
      t.index :token
    end
  end
end
