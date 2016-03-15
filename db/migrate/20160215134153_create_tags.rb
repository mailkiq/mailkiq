class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.index [:slug, :account_id], unique: true
      t.timestamps null: false
    end
  end
end
