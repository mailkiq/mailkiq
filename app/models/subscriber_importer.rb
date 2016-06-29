require 'csv'

class SubscriberImporter
  def initialize(account)
    @account = account
  end

  def process!(csv)
    @account.transaction do
      CSV.parse(csv) do |row|
        update_or_create! email: row[0], name: row[1]
      end
    end
  end

  private

  def update_or_create!(email:, name:)
    subscriber = @account.subscribers.find_or_initialize_by(email: email)
    subscriber.state = :active
    subscriber.name = name
    subscriber.save!
  end
end
