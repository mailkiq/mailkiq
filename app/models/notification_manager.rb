class NotificationManager
  attr_reader :account, :message

  delegate :subscription_confirmation?, :ses?, to: :message

  def initialize(account, message_body)
    @account = account
    @message = Aws::SNS::Message.load message_body
  end

  def confirm
    sns = Aws::SNS::Client.new account.credentials
    sns.confirm_subscription topic_arn: message.topic_arn, token: message.token
  end

  def create!
    notification = create_notification!

    account.subscribers.where(email: message.emails)
           .update_all(state: Subscriber.states.fetch(message.state))

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
    Campaign.increment_counter "#{notification.type.pluralize}_count".freeze,
                               notification.message.campaign_id
  end
end
