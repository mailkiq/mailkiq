require 'jwt'

module AuthToken
  module_function

  def secret_key_base
    Rails.application.secrets.secret_key_base
  end

  def encode(payload, ttl_in_minutes = 60 * 24 * 30)
    payload[:exp] = ttl_in_minutes.minutes.from_now.to_i
    JWT.encode payload, secret_key_base
  end

  def decode(token)
    decoded_token = JWT.decode token, secret_key_base
    HashWithIndifferentAccess.new decoded_token.first
  end
end
