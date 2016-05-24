require 'rails_helper'

describe MailerProcessor do
  let(:mail) do
    m = Mail.new
    m.html_part = File.read('spec/fixtures/template.html')
    m
  end

  subject do
    email = double
    allow(email).to receive(:mail).and_return(mail)
    allow(email).to receive(:utm_params).and_return(utm_source: :email)
    allow(email).to receive(:token).and_return('token')
    allow(email).to receive(:subscription_token).and_return Token.encode(1)
    described_class.new email
  end

  describe '#transform!' do
    let(:doc) do
      subject.transform!
      subject.send :parse, subject.send(:body).raw_source
    end

    it 'tracks open' do
      image = doc.at('body > img:last-child')

      expect(image[:src]).to eq('http://localhost:3000/track/open/token.gif')
      expect(image[:width]).to eq('1')
      expect(image[:height]).to eq('1')
      expect(image[:alt]).to be_empty
    end

    it 'tracks links' do
      link = Addressable::URI.parse doc.at('a').get_attribute(:href)

      expect(link.path).to eq('/track/click/token')
      expect(link.query_values['signature'].size).to eq(40)
      expect(link.query_values['url'])
        .to eq('http://saopaulo.votenaweb.com.br?utm_source=email')
    end

    it 'expands template variables' do
      node = doc.at('.unsubscribe')
      link = Addressable::URI.parse node.get_attribute(:href)

      expect(link.path).to eq('/unsubscribe')
      expect(link.query_values['token']).to eq(Token.encode(1))
    end
  end
end
