class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag, null: false, index: true, foreign_key: true
      t.belongs_to :subscriber, null: false, index: true, foreign_key: true
      t.datetime :created_at, null: false
    end
  end
end
