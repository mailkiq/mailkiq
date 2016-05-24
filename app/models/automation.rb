class Automation < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :account
  belongs_to :campaign
  accepts_nested_attributes_for :campaign
end
