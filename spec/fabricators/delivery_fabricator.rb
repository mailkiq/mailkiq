Fabricator(:delivery) do
  campaign fabricator: :campaign_with_account
  tagged_with ['mulherada a']
  not_tagged_with ['mulherada b']
end
