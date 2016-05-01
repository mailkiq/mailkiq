class ChangeNameColumn < ActiveRecord::Migration
  def change
    change_column_null :subscribers, :name, true
  end
end
