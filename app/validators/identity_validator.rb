class IdentityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if unverified_domain?(record, value)
      record.errors.add attribute, :unverified_domain
    elsif unverified_email_address?(record, value)
      record.errors.add attribute, :unverified_email_address
    end
  end

  private

  def unverified_domain?(record, value)
    mail = Mail::Address.new(value)
    names = record.send(domains_method_name)
    names.exclude? mail.domain
  end

  def unverified_email_address?(record, value)
    credentials = record.send(credentials_method_name)
    ses = Fog::AWS::SES.new(credentials)
    emails = ses.list_verified_email_addresses.body['VerifiedEmailAddresses']
    emails.exclude? value
  end

  def domains_method_name
    options.fetch(:domains, :account_domain_names)
  end

  def credentials_method_name
    options.fetch(:credentials, :account_credentials)
  end
end
