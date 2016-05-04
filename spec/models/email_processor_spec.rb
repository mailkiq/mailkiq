require 'rails_helper'

describe EmailProcessor, type: :model do
  let(:mail) do
    Mail.new do
      html_part do
        body File.read('spec/fixtures/template.html')
      end
    end
  end

  subject do
    email = double
    allow(email).to receive(:mail).and_return(mail)
    allow(email).to receive(:utm_params).and_return(utm_source: :email)
    allow(email).to receive(:token).and_return('token')
    described_class.new email
  end

  describe '#transform!' do
    let(:doc) do
      subject.transform!
      Nokogiri::XML.fragment(mail.html_part.body.raw_source)
    end

    it 'tracks open' do
      image = doc.at('img')

      expect(image[:src]).to eq('http://localhost:3000/track/opens/token.gif')
      expect(image[:width]).to eq('1')
      expect(image[:height]).to eq('1')
      expect(image[:alt]).to be_empty
    end

    it 'tracks links' do
      link = Addressable::URI.parse doc.at('a').get_attribute(:href)

      expect(link.path).to eq('/track/clicks/token')
      expect(link.query_values['signature'].size).to eq(40)
      expect(link.query_values['url'])
        .to eq('http://www.google.com?utm_source=email')
    end
  end
end
