class IdentityValidator < ActiveModel::Validator
  def validate(record)
    ses = Fog::AWS::SES.new(record.credentials)
    emails = ses.list_verified_email_addresses.body['VerifiedEmailAddresses']
    return if emails.include?(record.from_email)
    record.errors.add :from_email, :unverified_email_address
  end
end
