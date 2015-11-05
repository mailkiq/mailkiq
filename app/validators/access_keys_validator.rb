class AccessKeysValidator < ActiveModel::Validator
  def validate(record)
    auth = record.slice :aws_access_key_id, :aws_secret_access_key
    Fog::AWS::SES.new(auth).get_send_quota
  rescue Fog::AWS::SES::Error
    record.errors.add :aws_access_key_id, :invalid_token
  end
end
