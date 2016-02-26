class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price

      t.timestamps null: false
    end
  end
end
