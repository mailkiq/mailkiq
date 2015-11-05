class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists, force: :cascade do |t|
      t.string :name, null: false
      t.boolean :double_optin, null: false, default: false
      t.string :confirm_url
      t.string :subscribed_url
      t.string :unsubscribed_url
      t.boolean :thankyou, null: false, default: false
      t.string :thankyou_subject
      t.text :thankyou_message
      t.boolean :goodbye, null: false, default: false
      t.string :goodbye_subject
      t.text :goodbye_message
      t.string :confirmation_subject
      t.text :confirmation_message
      t.boolean :unsubscribe_all_list, null: false, default: true
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

=begin
+----------------------+------------------+------+-----+---------+----------------+
| Field                | Type             | Null | Key | Default | Extra          |
+----------------------+------------------+------+-----+---------+----------------+
| id                   | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| app                  | int(11)          | YES  |     | NULL    |                |
| userID               | int(11)          | YES  |     | NULL    |                |
| name                 | varchar(100)     | YES  |     | NULL    |                |
| opt_in               | int(11)          | YES  |     | 0       |                |
| confirm_url          | varchar(100)     | YES  |     | NULL    |                |
| subscribed_url       | varchar(100)     | YES  |     | NULL    |                |
| unsubscribed_url     | varchar(100)     | YES  |     | NULL    |                |
| thankyou             | int(11)          | YES  |     | 0       |                |
| thankyou_subject     | varchar(100)     | YES  |     | NULL    |                |
| thankyou_message     | mediumtext       | YES  |     | NULL    |                |
| goodbye              | int(11)          | YES  |     | 0       |                |
| goodbye_subject      | varchar(100)     | YES  |     | NULL    |                |
| goodbye_message      | mediumtext       | YES  |     | NULL    |                |
| confirmation_subject | mediumtext       | YES  |     | NULL    |                |
| confirmation_email   | mediumtext       | YES  |     | NULL    |                |
| unsubscribe_all_list | int(11)          | YES  |     | 1       |                |
| custom_fields        | mediumtext       | YES  |     | NULL    |                |
| prev_count           | int(100)         | YES  |     | 0       |                |
| currently_processing | int(100)         | YES  |     | 0       |                |
| total_records        | int(100)         | YES  |     | 0       |                |
+----------------------+------------------+------+-----+---------+----------------+
=end
