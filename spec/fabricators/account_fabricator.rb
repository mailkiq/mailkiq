Fabricator(:account) do
  name 'Jonh Doe'
  email { sequence(:email) { |i| "account#{i}@example.com" } }
  password 'testando'
  time_zone 'America/Sao_Paulo'
  aws_access_key_id 'anything'
  aws_secret_access_key 'anything'
  aws_region 'us-east-1'
  api_key SecureRandom.uuid
  used_credits 5
end

Fabricator(:valid_account, from: :account) do
  aws_access_key_id ENV['AWS_ACCESS_KEY_ID'] || 'dasdas'
  aws_secret_access_key ENV['AWS_SECRET_ACCESS_KEY'] || 'dasdas'
  aws_topic_arn 'arn:aws:sns:us-east-1:495707395447:mailkiq-2'
  aws_queue_url 'https://sqs.us-east-1.amazonaws.com/495707395447/mailkiq'
  paypal_customer_token '8LYFRSE963NP6'
  paypal_payment_token 'EC-24H44431DX200021P'
  paypal_recurring_profile_token 'I-27DBWXKB2XGP'
end

Fabricator(:jane_doe, from: :valid_account) do
  name 'Jane Doe'
  email 'jane@doe.com'
  password 'jane'
  language 'pt-BR'
  time_zone 'Buenos Aires'
  aws_region 'us-west-2'
end
