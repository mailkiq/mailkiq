class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :status, null: false
      t.belongs_to :list, null: false, index: true, foreign_key: true
      t.belongs_to :subscriber, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
