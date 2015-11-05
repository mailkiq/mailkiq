Fabricator(:list) do
  id 1
  name 'Ruby Developers'
end

Fabricator(:list_with_account, from: :list) do
  account fabricator: :valid_account
end
