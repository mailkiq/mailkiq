class DomainWorker
  include Sidekiq::Worker

  sidekiq_options queue: :platform, backtrace: true, unique: :until_executing

  def perform(account_id)
    @account = Account.find account_id
    @account.domains.each { |domain| update_verification_attributes(domain) }
  end

  private

  def ses
    @ses ||= Fog::AWS::SES.new(@account.credentials)
  end

  def update_verification_attributes(domain)
    response = ses.get_identity_verification_attributes([domain.name])
    response.body['VerificationAttributes'].each do |attributes|
      new_status = attributes['VerificationStatus'].underscore
      domain.update_columns(
        status: Domain.statuses[new_status],
        verification_token: attributes['VerificationToken']
      )
    end
  end
end
