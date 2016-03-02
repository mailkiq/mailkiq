class EnableExtensions < ActiveRecord::Migration
  def change
    enable_extension :citext
    enable_extension 'uuid-ossp'
  end
end
