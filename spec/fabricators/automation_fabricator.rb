Fabricator(:automation) do
  name 'Confirmation'
  subject '%first_name%, Obrigado'
  from_name 'Rainer'
  from_email 'rainer@mailkiq.com'
  html_text <<-EOF
    Obrigado

    %subscribe_url%
  EOF
  plain_text <<-EOF
    Obrigado

    %subscribe_url%
  EOF
end

Fabricator(:automation_with_account, from: :automation) do
  account
end
