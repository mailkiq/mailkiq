class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, null: false, index: true
      t.belongs_to :subscriber, null: false, index: true
      t.datetime :created_at, null: false
      t.foreign_key :tags, on_delete: :cascade
      t.foreign_key :subscribers, on_delete: :cascade
    end
  end
end
