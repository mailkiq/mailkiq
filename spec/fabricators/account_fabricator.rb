Fabricator(:account) do
  name 'John Doe'
  email 'account0@example.com'
  password 'testando'
  time_zone 'America/Sao_Paulo'
  language 'en'
  aws_access_key_id 'anything'
  aws_secret_access_key 'anything'
  aws_region 'us-east-1'
  api_key { SecureRandom.uuid }
  used_credits 5
end

Fabricator(:official_account, from: :account) do
  email 'rainerborene@gmail.com'
end

Fabricator(:paid_account, from: :account) do
  iugu_customer_id 'E89854FBE69A475798D57AF0B8427CB8'
  iugu_subscription_id 'ABC1C0EA9F4341568AA23EC5B5043743'
end

Fabricator(:valid_account, from: :account) do
  aws_access_key_id ENV['AWS_ACCESS_KEY_ID'] || 'dasdas'
  aws_queue_url 'https://sqs.us-east-1.amazonaws.com/495707395447/mailkiq'
  aws_secret_access_key ENV['AWS_SECRET_ACCESS_KEY'] || 'dasdas'
  aws_topic_arn 'arn:aws:sns:us-east-1:495707395447:mailkiq-2'
  credit_card_token '5E5C5CC5-2412-476E-A8E5-5A50B3B79397'
  plan 'essentials_plan'
end

Fabricator(:jane_doe, from: :valid_account) do
  name 'Jane Doe'
  email 'jane@doe.com'
  password 'janedoe123'
  language 'pt-BR'
  time_zone 'Buenos Aires'
  aws_region 'us-west-2'
end
