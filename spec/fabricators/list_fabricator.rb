Fabricator(:list) do
  name 'Ruby Developers'
end

Fabricator(:list_with_account, from: :list) do
  account fabricator: :valid_account
end
