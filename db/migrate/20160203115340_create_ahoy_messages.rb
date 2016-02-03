class CreateAhoyMessages < ActiveRecord::Migration
  def change
    create_table :ahoy_messages do |t|
      t.string :token

      # user
      t.text :to, null: false
      t.references :user, null: false, polymorphic: true, index: true

      # campaign
      t.belongs_to :campaign, null: false, index: true, foreign_key: true

      # timestamps
      t.timestamp :sent_at
      t.timestamp :opened_at
      t.timestamp :clicked_at

      # indexes
      t.index :token
    end
  end
end
