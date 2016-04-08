class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.citext :slug, null: false
      t.belongs_to :account, null: false, index: true
      t.timestamps null: false
      t.foreign_key :accounts, on_delete: :cascade
      t.index [:slug, :account_id], unique: true
    end
  end
end
