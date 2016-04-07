class DomainWorker
  include Sidekiq::Worker

  sidekiq_options queue: :platform, backtrace: true, unique: :until_executing

  def perform(account_id)
    @account = Account.find account_id
    @account.domains.each do |domain|
      update_verification_attributes(domain)
      enable_identity_dkim(domain) if domain.success?
    end
  end

  private

  def ses
    @ses ||= Aws::SES::Client.new(@account.credentials)
  end

  def enable_identity_dkim(domain)
    ses.set_identity_dkim_enabled identity: domain.name, dkim_enabled: true
  end

  def update_verification_attributes(domain)
    resp = ses.get_identity_verification_attributes(identities: [domain.name])
    attributes = resp.verification_attributes[domain.name]
    domain.update_columns(
      status: Domain.statuses[attributes.verification_status.underscore],
      verification_token: attributes.verification_token
    )
  end
end
