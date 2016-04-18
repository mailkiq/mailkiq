class AccessKeysValidator < ActiveModel::Validator
  def validate(record)
    Aws::SES::Client.new(record.aws_options).get_send_quota
  rescue Aws::SES::Errors::InvalidClientTokenId
    record.errors.add :aws_access_key_id, :invalid_token
  end
end
