class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :state, null: false
      t.jsonb :custom_fields, null: false, default: {}
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps null: false
      t.index [:account_id, :email], unique: true
      t.index :custom_fields, using: :gin
    end
  end
end

=begin
+---------------+------------------+------+-----+---------+----------------+
| Field         | Type             | Null | Key | Default | Extra          |
+---------------+------------------+------+-----+---------+----------------+
| id            | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| userID        | int(11)          | YES  |     | NULL    |                |
| name          | varchar(100)     | YES  |     | NULL    |                |
| email         | varchar(100)     | YES  | MUL | NULL    |                |
| custom_fields | longtext         | YES  |     | NULL    |                |
| list          | int(11)          | YES  | MUL | NULL    |                |
| unsubscribed  | int(11)          | YES  | MUL | 0       |                |
| bounced       | int(11)          | YES  | MUL | 0       |                |
| bounce_soft   | int(11)          | YES  | MUL | 0       |                |
| complaint     | int(11)          | YES  | MUL | 0       |                |
| last_campaign | int(11)          | YES  |     | NULL    |                |
| last_ares     | int(11)          | YES  |     | NULL    |                |
| timestamp     | int(100)         | YES  | MUL | NULL    |                |
| join_date     | int(100)         | YES  |     | NULL    |                |
| confirmed     | int(11)          | YES  | MUL | 1       |                |
| messageID     | varchar(100)     | YES  |     | NULL    |                |
+---------------+------------------+------+-----+---------+----------------+
=end
