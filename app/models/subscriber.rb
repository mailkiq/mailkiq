class Subscriber < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :email, scope: :account_id
  validates :email, presence: true, email: true
  belongs_to :account
  has_many :messages, class_name: 'Ahoy::Message', dependent: :destroy, as: :user
  paginates_per 25
end
