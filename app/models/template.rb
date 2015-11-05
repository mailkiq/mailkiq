class Template < ActiveRecord::Base
  validates_presence_of :name, :html_text
  belongs_to :account
end
