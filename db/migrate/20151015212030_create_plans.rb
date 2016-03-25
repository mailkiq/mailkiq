class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.citext :name, null: false
      t.decimal :price, null: false
      t.integer :credits, null: false
      t.timestamps null: false
      t.index :name, unique: true
    end
  end
end
