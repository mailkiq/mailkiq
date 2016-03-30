class DomainIdentity
  def initialize(domain)
    @domain = domain
    @ses = Aws::SES::Client.new(domain.account.credentials)
  end

  def verify!
    return false unless @domain.valid?

    @domain.transaction do
      @domain.status = Domain.statuses[:pending]
      @domain.verification_token = verification_token
      @domain.dkim_tokens = dkim_tokens
      @domain.save
    end

    set_identity_notification_topics
  end

  def delete!
    @domain.transaction do
      @ses.delete_identity identity: @domain.name
      @domain.destroy
    end
  end

  private

  def set_identity_notification_topic(type)
    @ses.set_identity_notification_topic(
      identity: @domain.name,
      sns_topic: @domain.account.aws_topic_arn,
      notification_type: type
    )
  end

  def set_identity_notification_topics
    set_identity_notification_topic :Bounce
    set_identity_notification_topic :Complaint
    set_identity_notification_topic :Delivery

    @ses.set_identity_feedback_forwarding_enabled identity: @domain.name,
                                                  forwarding_enabled: false
  end

  def dkim_tokens
    @ses.verify_domain_dkim(domain: @domain.name).dkim_tokens
  end

  def verification_token
    @ses.verify_domain_identity(domain: @domain.name).verification_token
  end
end
