class Subscriber < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  has_many :messages, class_name: 'Ahoy::Message', as: :user
  belongs_to :account
end
