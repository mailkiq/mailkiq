Fabricator(:subscriber) do
  name 'Rainer Borene'
  email 'rainer@mailkiq.com'
  state 'active'
end

Fabricator(:maria_doe, from: :subscriber) do
  name 'Maria Doe'
  email 'maria@doe.com'
end
