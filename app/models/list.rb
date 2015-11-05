class List < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :thankyou_subject, :thankyou_message, if: :thankyou?
  validates_presence_of :goodbye_subject, :goodbye_message, if: :goodbye?
  validates_format_of :confirm_url, :subscribed_url, :unsubscribed_url,
                      with: URI.regexp(%w(http https)), allow_blank: true

  belongs_to :account
  has_many :subscriptions, dependent: :delete_all
  has_many :subscribers, through: :subscriptions
  has_many :custom_fields, dependent: :destroy
end
