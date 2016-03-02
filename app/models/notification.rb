class Notification < ActiveRecord::Base
  belongs_to :message
  enum type: [:bounce, :complaint, :delivery]

  def self.inheritance_column
    nil
  end
end
