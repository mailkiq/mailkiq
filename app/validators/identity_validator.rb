class IdentityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if unverified_domain?(record, value)
      record.errors.add attribute, :unverified_domain
    elsif unverified_email_address?(record, value)
      record.errors.add attribute, :unverified_email_addresss
    end
  end

  private

  def unverified_domain?(record, value)
    mail = Mail::Address.new(value)
    names = record.send options.fetch(:domains_method)
    names.exclude? mail.domain
  end

  def unverified_email_address?(record, value)
    credentials = record.send options.fetch(:credentials_method)
    ses = Fog::AWS::SES.new(credentials)
    emails = ses.list_verified_email_addresses.body['VerifiedEmailAddresses']
    emails.exclude? value
  end
end
