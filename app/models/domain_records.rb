class DomainRecords
  Entry = Struct.new(:name, :value)

  attr_reader :domain

  def initialize(domain)
    @domain = domain
  end

  def txt_name
    "_amazonses.#{domain.name}"
  end

  def txt_value
    domain.verification_token
  end

  def mx_name
    "bounce.#{domain.name}"
  end

  def mx_value
    'feedback-smtp.us-east-1.amazonses.com'
  end

  def spf_name
    "bounce.#{domain.name}"
  end

  def spf_value
    'v=spf1 include:amazonses.com ~all'
  end

  def cnames
    domain.dkim_tokens.map do |token|
      Entry.new "#{token}._domainkey.#{domain.name}",
                "#{token}.dkim.amazonses.com"
    end
  end
end
