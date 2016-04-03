class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name, null: false

      ## Database authenticatable
      t.citext :email, null: false
      t.string :encrypted_password, null: false

      ## Custom Preferences
      t.string :language
      t.string :time_zone, default: 'UTC'
      t.uuid :api_key, null: false, default: 'uuid_generate_v4()'

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Amazon Access Keys
      t.string :aws_access_key_id
      t.string :aws_secret_access_key
      t.string :aws_region
      t.string :aws_topic_arn

      ## PayPal Payment
      t.string :paypal_customer_token
      t.string :paypal_recurring_profile_token
      t.belongs_to :plan, null: false, foreign_key: true

      t.timestamps null: false

      t.index :reset_password_token, unique: true
      t.index :email, unique: true
      t.index :api_key, unique: true
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
