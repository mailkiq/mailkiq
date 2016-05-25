class MoveTypeColumnToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :state, :integer, default: 0, null: false
    remove_column :notifications, :type, :integer
  end
end
