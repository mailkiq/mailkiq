Fabricator(:domain) do
  account fabricator: :valid_account
  name 'example.com'
  verification_token 'blah'
  verification_status 1
  dkim_tokens ['a']
end
