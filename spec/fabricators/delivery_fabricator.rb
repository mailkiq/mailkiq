Fabricator(:delivery) do
  account
  campaign
  tagged_with ['mulherada a']
  not_tagged_with ['mulherada b']
end
