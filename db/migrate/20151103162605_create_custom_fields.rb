class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.string :key, null: false
      t.integer :data_type, null: false, default: 0
      t.string :field_name, null: false
      t.boolean :hidden, null: false, default: false
      t.belongs_to :list, null: false, index: true, foreign_key: true
      t.index [:field_name, :list_id], unique: true
      t.timestamps null: false
    end
  end
end
