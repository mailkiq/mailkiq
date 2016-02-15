class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :subscriber
      t.datetime :created_at, null: false
    end
  end
end
