Fabricator(:message) do
  uuid 'MessageId'
  token 'zS0DBOakuHD8G9a0O3zLbVahLez5sTK0'
  referer 'http://www.gmail.com'
  user_agent 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8) Gecko/20060206 Songbird/0.1'
end

Fabricator(:message_with_associations, from: :message) do
  campaign fabricator: :renderable_campaign
  subscriber
  token 'tokenz'
end
