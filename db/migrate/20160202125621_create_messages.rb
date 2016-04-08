class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :uuid, null: false, limit: 60
      t.string :token, null: false, limit: 32
      t.string :referer
      t.string :user_agent
      t.inet :ip_address

      t.belongs_to :subscriber, null: false, index: true
      t.belongs_to :campaign, null: false, index: true

      t.timestamp :sent_at, null: false
      t.timestamp :opened_at
      t.timestamp :clicked_at

      t.foreign_key :subscribers, on_delete: :cascade
      t.foreign_key :campaigns, on_delete: :cascade
      t.index :uuid
      t.index :token
    end
  end
end
