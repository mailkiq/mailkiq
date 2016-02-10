Fabricator(:campaign) do
  name 'The Truth About Wheat'
  subject 'The Truth About Wheat'
  from_name 'Rainer Borene'
  from_email 'rainer@thoughtplane.com'
  html_text 'Testing'
end

Fabricator(:freeletics_campaign, from: :campaign) do
  name 'Coma direito e duplique o resultado dos treinos'
end
