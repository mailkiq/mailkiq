class DomainIdentity
  def initialize(domain)
    @domain = domain
    @ses = Aws::SES::Client.new(@domain.account_aws_options)
  end

  def verify!
    return false unless @domain.valid?

    @domain.transaction do
      @domain.verification_token = verification_token
      @domain.dkim_tokens = dkim_tokens
      @domain.all_pending!
      @domain.save
    end

    associate_notification_topics
    set_identity_mail_from_domain
  end

  def update!
    @domain.transaction do
      @domain.verification_status = verification_status
      @domain.dkim_verification_status = dkim_verification_status
      @domain.mail_from_domain_status = mail_from_domain_status
      @domain.save
    end

    enable_identity_dkim if @domain.dkim_success? || @domain.dkim_failed?
    set_identity_mail_from_domain if @domain.mail_from_failed?
  end

  def delete!
    @domain.transaction do
      @ses.delete_identity identity: @domain.name
      @domain.destroy
    end
  end

  private

  def enable_identity_dkim
    @ses.set_identity_dkim_enabled identity: @domain.name, dkim_enabled: true
  end

  def verification_token
    @ses.verify_domain_identity(domain: @domain.name).verification_token
  end

  def dkim_tokens
    @ses.verify_domain_dkim(domain: @domain.name).dkim_tokens
  end

  def dkim_verification_status
    resp = @ses.get_identity_dkim_attributes identities: [@domain.name]
    attributes = resp.dkim_attributes[@domain.name]
    status = attributes.dkim_verification_status.underscore
    Domain.dkim_verification_statuses[status]
  end

  def mail_from_domain_status
    identities = [@domain.name]
    resp = @ses.get_identity_mail_from_domain_attributes identities: identities
    attributes = resp.mail_from_domain_attributes[@domain.name]
    status = attributes.mail_from_domain_status.underscore
    Domain.mail_from_domain_statuses[status]
  end

  def verification_status
    resp = @ses.get_identity_verification_attributes identities: [@domain.name]
    attributes = resp.verification_attributes[@domain.name]
    status = attributes.verification_status.underscore
    Domain.verification_statuses[status]
  end

  def associate_notification_topic(type)
    @ses.set_identity_notification_topic(
      identity: @domain.name,
      sns_topic: @domain.account_aws_topic_arn,
      notification_type: type
    )
  end

  def associate_notification_topics
    associate_notification_topic :Bounce
    associate_notification_topic :Complaint
    associate_notification_topic :Delivery

    @ses.set_identity_feedback_forwarding_enabled identity: @domain.name,
                                                  forwarding_enabled: false
  end

  def set_identity_mail_from_domain
    @ses.set_identity_mail_from_domain(
      identity: @domain.name,
      mail_from_domain: "bounce.#{@domain.name}",
      behavior_on_mx_failure: 'UseDefaultValue'
    )
  end
end
