class AccessKeysValidator < ActiveModel::Validator
  def validate(record)
    Fog::AWS::SES.new(record.credentials).get_send_quota
  rescue Fog::AWS::SES::Error
    record.errors.add :aws_access_key_id, :invalid_token
  end
end
