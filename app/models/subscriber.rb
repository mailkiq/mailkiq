class Subscriber < ActiveRecord::Base
  validates_presence_of :name
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :subscriptions, dependent: :delete_all
  has_many :lists, through: :subscriptions
end
