Fabricator(:domain) do
  account
  name 'patriotas.net'
  verification_token 'blah'
  dkim_tokens ['a']
  status 1
end
