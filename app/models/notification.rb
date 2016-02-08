class Notification < ActiveRecord::Base
  belongs_to :message, foreign_key: :message_uid, primary_key: :uid
end
