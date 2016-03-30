Fabricator(:domain) do
  account
  name 'example.com'
  verification_token 'blah'
  dkim_tokens ['a']
  status 1
end
