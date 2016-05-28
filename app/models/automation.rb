class Automation < Campaign
  validate :require_subscribe_url, if: :subscription_confirmation?

  TYPES = [:subscription_confirmation].freeze

  self.default_scopes = []

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

  def set_default_state
    self.state ||= self.class.states[:sending]
  end
end
