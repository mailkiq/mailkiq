class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts, force: :cascade do |t|
      t.string :name, null: false
      t.citext :email, null: false
      t.string :encrypted_password, limit: 128
      t.string :confirmation_token, limit: 128
      t.string :remember_token, limit: 128
      t.string :aws_access_key_id
      t.string :aws_secret_access_key
      t.string :aws_region
      t.string :language
      t.string :time_zone
      t.index :remember_token
      t.index :email, unique: true
    end
  end
end

=begin
+--------------+------------------+------+-----+---------+----------------+
| Field        | Type             | Null | Key | Default | Extra          |
+--------------+------------------+------+-----+---------+----------------+
| id           | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| name         | varchar(100)     | YES  |     | NULL    |                |
| company      | varchar(100)     | YES  |     | NULL    |                |
| username     | varchar(100)     | YES  |     | NULL    |                |
| password     | varchar(500)     | YES  |     | NULL    |                |
| s3_key       | varchar(500)     | YES  |     | NULL    |                |
| s3_secret    | varchar(500)     | YES  |     | NULL    |                |
| api_key      | varchar(500)     | YES  |     | NULL    |                |
| license      | varchar(100)     | YES  |     | NULL    |                |
| timezone     | varchar(100)     | YES  |     | NULL    |                |
| tied_to      | int(11)          | YES  |     | NULL    |                |
| app          | int(11)          | YES  |     | NULL    |                |
| paypal       | varchar(100)     | YES  |     | NULL    |                |
| cron         | int(11)          | YES  |     | 0       |                |
| cron_ares    | int(11)          | YES  |     | 0       |                |
| send_rate    | int(100)         | YES  |     | 0       |                |
| language     | varchar(100)     | YES  |     | en_US   |                |
| cron_csv     | int(11)          | YES  |     | 0       |                |
| ses_endpoint | varchar(100)     | YES  |     | NULL    |                |
+--------------+------------------+------+-----+---------+----------------+
=end
