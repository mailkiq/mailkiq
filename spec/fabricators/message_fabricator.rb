require 'signature'

Fabricator(:message) do
  uuid 'MessageId'
  token 'zS0DBOakuHD8G9a0O3zLbVahLez5sTK0'
  referer 'http://www.gmail.com'
  user_agent 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8)'
end

Fabricator(:message_with_associations, from: :message) do
  campaign fabricator: :renderable_campaign
  subscriber
  token 'tokenz'
end

Fabricator(:message_event, from: OpenStruct) do
  referer 'https://www.google.com.br'
  remote_ip '131.233.206.58'
  user_agent 'Mozilla Firefox'
  signature Signature.hexdigest('http://www.google.com.br')
  url 'http://www.google.com.br'
end
