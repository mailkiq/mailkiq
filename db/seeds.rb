require 'faker'

Faker::Config.locale = 'pt-BR'

Account.destroy_all
Campaign.destroy_all
Subscriber.destroy_all
Domain.delete_all

account = Account.find_or_create_by!(email: 'rainerborene@gmail.com') do |a|
  a.name = 'Rainer Borene'
  a.email = 'rainerborene@gmail.com'
  a.password = 'teste'
  a.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
  a.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
end

domain = Domain.find_or_create_by!(name: 'thoughtplane.com', account: account)
domain.update_column :status, Domain.statuses[:success]

campaign = Campaign.create!(
  name: 'O seu Informe de Rendimentos já está disponível',
  subject: 'O seu Informe de Rendimentos já está disponível',
  from_name: 'Rainer',
  from_email: 'rainer@thoughtplane.com',
  html_text: 'It works',
  account_id: account.id
)

20.times do
  now = Time.now
  future = 3.days.from_now

  subscriber = Subscriber.create! name: Faker::Name.name,
                                  email: Faker::Internet.email,
                                  state: Subscriber.states[:active],
                                  account_id: account.id

  Message.create! uuid: SecureRandom.uuid,
                  token: SecureRandom.hex,
                  subscriber_id: subscriber.id,
                  campaign_id: campaign.id,
                  opened_at: Faker::Time.between(now, future, :all),
                  sent_at: now
end
