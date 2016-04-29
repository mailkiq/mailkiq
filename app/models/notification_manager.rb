class NotificationManager
  attr_reader :message, :account_id

  delegate :ses?, to: :message

  def initialize(body, account_id)
    @message = Aws::SNS::Message.load body
    @account_id = account_id
  end

  def create!
    notification = create_notification!

    Subscriber.where(email: message.emails, account_id: account_id)
              .update_all(state: Subscriber.states[message.state])

    increment_counter(notification) unless notification.delivery?
  end

  def attributes
    { type: message.message_type.downcase, data: message.data.as_json }
  end

  private

  def create_notification!
    record = Message.find_by! uuid: message.mail_id
    record.notifications.create! attributes
  end

  def increment_counter(notification)
    counter_name = "#{notification.type.pluralize}_count".freeze
    Campaign.increment_counter counter_name, notification.message.campaign_id
  end
end
