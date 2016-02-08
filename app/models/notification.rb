class Notification < ActiveRecord::Base
  belongs_to :message, foreign_key: :message_uid, primary_key: :uid
  enum type: [:bounce, :complaint, :delivery]

  def self.inheritance_column
    nil
  end
end
