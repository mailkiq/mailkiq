class Automation < Campaign
  self.default_scopes = []

  TYPES = [:subscription_confirmation].freeze

  validate :require_subscribe_url, if: :subscription_confirmation?

  def self.confirmation
    sending.where("send_settings->>'type' = ?", TYPES.first)
  end

  def send_type
    send_settings['type']
  end

  def send_type=(value)
    send_settings['type'] = value
  end

  def subscription_confirmation?
    send_type == 'subscription_confirmation'
  end

  private

  def exclude_subscribe_url?(text)
    text.present? && text.exclude?('%subscribe_url%')
  end

  def require_subscribe_url
    if exclude_subscribe_url? html_text
      errors.add(:html_text, :subscribe_not_found)
    end

    if exclude_subscribe_url? plain_text
      errors.add(:plain_text, :subscribe_not_found)
    end
  end
end
