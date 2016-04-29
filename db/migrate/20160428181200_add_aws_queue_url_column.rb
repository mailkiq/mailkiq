class AddAwsQueueUrlColumn < ActiveRecord::Migration
  def change
    add_column :accounts, :aws_queue_url, :string
  end
end
