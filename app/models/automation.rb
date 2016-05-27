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

  def require_subscribe_url
    if html_text.to_s.exclude? '%subscribe_url%'
      errors.add(:html_text, :subscribe_not_found)
    end
  end

  def set_default_state
    self.state ||= self.class.states[:sending]
  end
end
