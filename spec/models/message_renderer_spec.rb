require 'rails_helper'

RSpec.describe MessageRenderer, type: :model do
  let(:message) { Fabricate.build :message_with_associations }

  subject { described_class.new message }

  describe '#render!' do
    before { subject.render! }

    let(:html) do
      Nokogiri::HTML(subject.to_html)
    end

    it 'tracks open' do
      image = html.at('body > img:last-child')

      expect(image[:src]).to eq('http://localhost:5000/track/open/tokenz.gif')
      expect(image[:width]).to eq('1')
      expect(image[:height]).to eq('1')
      expect(image[:alt]).to be_empty
    end

    it 'tracks links' do
      link = Addressable::URI.parse html.at('a').get_attribute(:href)

      expect(link.path).to eq('/track/click/tokenz')
      expect(link.query_values['signature'].size).to eq(40)

      redirect_url = Addressable::URI.parse link.query_values['url']
      expect(redirect_url.host).to eq('saopaulo.votenaweb.com.br')
      expect(redirect_url.query_values['utm_source']).to eq('mailkiq')
      expect(redirect_url.query_values['utm_medium']).to eq('email')
      expect(redirect_url.query_values['utm_campaign'])
        .to eq(message.campaign.name.parameterize)
    end

    it 'expands template variables on html format' do
      node = html.at('.unsubscribe')
      link = Addressable::URI.parse node.get_attribute(:href)
      token = Token.encode(message.subscriber.id)

      expect(link.path).to eq("/subscriptions/#{token}/unsubscribe")
    end

    it 'expands template variables on text format' do
      expect(subject.to_text).to_not include('%subscribe_url%')
    end
  end
end
