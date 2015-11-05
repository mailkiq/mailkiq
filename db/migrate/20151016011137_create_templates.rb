class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.text :html_text, null: false
      t.belongs_to :account, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

=begin
+---------------+------------------+------+-----+---------+----------------+
| Field         | Type             | Null | Key | Default | Extra          |
+---------------+------------------+------+-----+---------+----------------+
| id            | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
| userID        | int(11)          | YES  |     | NULL    |                |
| app           | int(11)          | YES  |     | NULL    |                |
| template_name | varchar(100)     | YES  |     | NULL    |                |
| html_text     | mediumtext       | YES  |     | NULL    |                |
+---------------+------------------+------+-----+---------+----------------+
=end
