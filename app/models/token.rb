module Token
  module_function

  def secret_key_base
    @secret_key_base ||= Rails.application.secrets.secret_key_base
  end

  def encode(payload)
    verifier = ActiveSupport::MessageVerifier.new(secret_key_base)
    verifier.generate(payload)
  end

  def decode(token)
    verifier = ActiveSupport::MessageVerifier.new(secret_key_base)
    verifier.verify(token)
  end
end
