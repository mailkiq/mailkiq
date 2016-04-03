Fabricator(:plan) do
  name { sequence(:name) { |i| "Basic #{i}" } }
  price 199
  credits 100_000
end
