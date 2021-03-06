class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.citext :name, null: false
      t.string :subject, null: false
      t.string :from_name, null: false
      t.string :from_email, null: false
      t.string :reply_to
      t.text :plain_text
      t.text :html_text, null: false

      # counter cache
      t.integer :recipients_count, null: false, default: 0
      t.integer :unique_opens_count, null: false, default: 0
      t.integer :unique_clicks_count, null: false, default: 0
      t.integer :rejects_count, null: false, default: 0
      t.integer :bounces_count, null: false, default: 0
      t.integer :complaints_count, null: false, default: 0

      t.belongs_to :account, null: false, index: true

      t.datetime :sent_at
      t.timestamps null: false
      t.foreign_key :accounts, on_delete: :cascade
      t.index [:name, :account_id], unique: true
    end
  end
end

=begin
+-----------------+------------------+------+-----+---------+----------------+
| Field           | Type             | Null | Key | Default | Extra          |
+-----------------+------------------+------+-----+---------+----------------+
| id              | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| userID          | int(11)          | YES  |     | NULL    |                |
| app             | int(11)          | YES  |     | NULL    |                |
| from_name       | varchar(100)     | YES  |     | NULL    |                |
| from_email      | varchar(100)     | YES  |     | NULL    |                |
| reply_to        | varchar(100)     | YES  |     | NULL    |                |
| title           | varchar(500)     | YES  |     | NULL    |                |
| label           | varchar(500)     | YES  |     | NULL    |                |
| plain_text      | mediumtext       | YES  |     | NULL    |                |
| html_text       | mediumtext       | YES  |     | NULL    |                |
| query_string    | varchar(500)     | YES  |     | NULL    |                |
| sent            | varchar(100)     | YES  |     |         |                |
| to_send         | int(100)         | YES  |     | NULL    |                |
| to_send_lists   | text             | YES  |     | NULL    |                |
| recipients      | int(100)         | YES  |     | 0       |                |
| timeout_check   | varchar(100)     | YES  |     | NULL    |                |
| opens           | longtext         | YES  |     | NULL    |                |
| wysiwyg         | int(11)          | YES  |     | 0       |                |
| send_date       | varchar(100)     | YES  |     | NULL    |                |
| lists           | text             | YES  |     | NULL    |                |
| timezone        | varchar(100)     | YES  |     | NULL    |                |
| errors          | longtext         | YES  |     | NULL    |                |
| bounce_setup    | int(11)          | YES  |     | 0       |                |
| complaint_setup | int(11)          | YES  |     | 0       |                |
+-----------------+------------------+------+-----+---------+----------------+
=end
