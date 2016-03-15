class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :uuid, null: false, limit: 60
      t.string :token, null: false, limit: 32
      t.string :referer
      t.string :user_agent
      t.inet :ip_address

      t.belongs_to :subscriber, null: false, index: true, foreign_key: true
      t.belongs_to :campaign, null: false, index: true, foreign_key: true

      t.timestamp :sent_at, null: false
      t.timestamp :opened_at
      t.timestamp :clicked_at

      t.index :uuid
      t.index :token
    end
  end
end
