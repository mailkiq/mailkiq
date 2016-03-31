class DomainIdentity
  attr_reader :domain, :ses

  def initialize(domain)
    @domain = domain
    @ses = Aws::SES::Client.new(domain.account_credentials)
  end

  def verify!
    return false unless domain.valid?

    domain.transaction do
      domain.status = Domain.statuses[:pending]
      domain.verification_token = verification_token
      domain.dkim_tokens = dkim_tokens
      domain.save
    end

    associate_notification_topics
  end

  def delete!
    domain.transaction do
      ses.delete_identity identity: domain.name
      domain.destroy
    end
  end

  private

  def dkim_tokens
    ses.verify_domain_dkim(domain: domain.name).dkim_tokens
  end

  def verification_token
    ses.verify_domain_identity(domain: domain.name).verification_token
  end

  def associate_notification_topic(type)
    ses.set_identity_notification_topic(
      identity: domain.name,
      sns_topic: domain.account_aws_topic_arn,
      notification_type: type
    )
  end

  def associate_notification_topics
    associate_notification_topic :Bounce
    associate_notification_topic :Complaint
    associate_notification_topic :Delivery

    ses.set_identity_feedback_forwarding_enabled identity: domain.name,
                                                 forwarding_enabled: false
  end
end
