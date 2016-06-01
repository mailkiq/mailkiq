require_dependency 'aws/sns/message'

class NotificationManager
  def initialize(body, account_id)
    @message = Aws::SNS::Message.load body
    @account_id = account_id
  end

  def ses?
    @message.ses?
  end

  def create!
    notification = track_notification!

    Subscriber.update_state state: @message.state,
                            email: @message.emails,
                            account_id: @account_id

    unless @message.state == :active
      Campaign.increment_counter counter_name, notification.message.campaign_id
    end
  end

  private

  def track_notification!
    record = Message.find_by! uuid: @message.mail_id
    record.update_column :state, Message.states[@message.message_type.downcase]
    record.notifications.create! data: @message.data.as_json
  end

  def counter_name
    "#{@message.message_type.downcase.pluralize}_count".freeze
  end
end
