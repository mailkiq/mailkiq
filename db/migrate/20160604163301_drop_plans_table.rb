class DropPlansTable < ActiveRecord::Migration
  def up
    remove_column :accounts, :plan_id
    drop_table :plans
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
