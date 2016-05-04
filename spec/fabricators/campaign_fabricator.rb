Fabricator(:campaign) do
  name 'The Truth About Wheat'
  subject 'The Truth About Wheat'
  from_name 'Rainer Borene'
  from_email 'rainer@mailkiq.com'
  plain_text 'it works'
  html_text <<-EOF
    Hello World!

    %unsubscribe_url%
  EOF
end

Fabricator(:sent_campaign, from: :campaign) do
  sent_at Time.now
  recipients_count 10
  unique_opens_count 10
  unique_clicks_count 10
end

Fabricator(:campaign_with_account, from: :campaign) do
  id 1
  account
  sent_at Time.now
  recipients_count 600_000
end

Fabricator(:freeletics_campaign, from: :campaign) do
  name 'Coma direito e duplique o resultado dos treinos'
end
