Fabricator(:subscriber) do
  name 'John Doe'
  email 'john@doe.com'
end

Fabricator(:maria_doe, from: :subscriber) do
  name 'Maria Doe'
  email 'maria@doe.com'
end
