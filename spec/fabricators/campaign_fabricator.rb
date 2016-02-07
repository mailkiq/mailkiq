Fabricator(:campaign) do
  name 'The Truth About Wheat'
  subject 'The Truth About Wheat'
  from_name 'Jonh Doe'
  from_email 'jonh@doe.com'
  html_text 'Testing'
end

Fabricator(:freeletics_campaign, from: :campaign) do
  name 'Coma direito e duplique o resultado dos treinos'
end
