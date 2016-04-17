class RemoveRejectsColumn < ActiveRecord::Migration
  def change
    remove_column :campaigns, :rejects_count
  end
end
