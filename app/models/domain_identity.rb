class DomainIdentity
  def initialize(domain)
    @domain = domain
    @ses = Fog::AWS::SES.new(domain.account.credentials)
  end

  def verify!
    return false unless @domain.valid?

    @domain.transaction do
      @domain.status = Domain.statuses[:pending]
      @domain.verification_token = verification_token
      @domain.dkim_tokens = dkim_tokens
      @domain.save
    end

    set_identity_notification_topic
  end

  def delete!
    @domain.transaction do
      @ses.delete_identity(@domain.name)
      @domain.destroy
    end
  end

  private

  def topic_arn
    @domain.account.aws_topic_arn
  end

  def set_identity_notification_topic
    @ses.set_identity_notification_topic(@domain.name, 'Bounce', topic_arn)
    @ses.set_identity_notification_topic(@domain.name, 'Complaint', topic_arn)
    @ses.set_identity_notification_topic(@domain.name, 'Delivery', topic_arn)
    @ses.set_identity_feedback_forwarding_enabled(false, @domain.name)
  end

  def dkim_tokens
    @ses.verify_domain_dkim(@domain.name).body['DkimTokens']
  end

  def verification_token
    @ses.verify_domain_identity(@domain.name).body['VerificationToken']
  end
end
