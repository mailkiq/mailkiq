Fabricator(:account) do
  name 'Jonh Doe'
  email { sequence(:email) { |i| "account#{i}@example.com" } }
  password 'jonhdoe'
  time_zone 'America/Sao_Paulo'
  aws_access_key_id 'anything'
  aws_secret_access_key 'anything'
  aws_region 'us-east-1'
  api_key SecureRandom.uuid
  plan
end

Fabricator(:valid_account, from: :account) do
  aws_access_key_id ENV['AWS_ACCESS_KEY_ID']
  aws_secret_access_key ENV['AWS_SECRET_ACCESS_KEY']
  aws_topic_arn 'arn:aws:sns:us-east-1:390722072336:ses-bounces-topic'
end

Fabricator(:jane_doe, from: :valid_account) do
  name 'Jane Doe'
  email 'jane@doe.com'
  password 'jane'
  language 'pt-BR'
  time_zone 'Buenos Aires'
  aws_region 'us-west-2'
end
