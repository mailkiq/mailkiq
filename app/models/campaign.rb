class Campaign < ActiveRecord::Base
  validates_presence_of :name, :subject, :from_name, :html_text
  validates :from_email, presence: true, email: true
  belongs_to :account

  def sender
    "#{from_name} <#{from_email}>"
  end
end
