Fabricator(:subscriber) do
  name 'Rainer Borene'
  email 'rainer@mailkiq.com'
  state 'active'
end

Fabricator(:subscriber_with_dot, from: :subscriber) do
  email 'franrodrigues1962@.gmail..com'
end

Fabricator(:maria_doe, from: :subscriber) do
  name 'Maria Doe'
  email 'maria@doe.com'
end
