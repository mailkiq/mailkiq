require 'spec_helper'
require 'pony'

RSpec.describe Pony do
  describe 'builds a Mail object with field:' do
    it 'to' do
      expect(Pony.build_mail(to: 'joe@example.com').to)
        .to eq(['joe@example.com'])
    end

    it 'to with multiple recipients' do
      expect(Pony.build_mail(to: 'joe@example.com, friedrich@example.com').to)
        .to eq(['joe@example.com', 'friedrich@example.com'])
    end

    it 'to with multiple recipients and names' do
      to = 'joe@example.com, "Friedrich Hayek" <friedrich@example.com>'
      expect(Pony.build_mail(to: to).to)
        .to eq(['joe@example.com', 'friedrich@example.com'])
    end

    it 'to with multiple recipients and names in an array' do
      to = ['joe@example.com', '"Friedrich Hayek" <friedrich@example.com>']
      expect(Pony.build_mail(to: to).to)
        .to eq(['joe@example.com', 'friedrich@example.com'])
    end

    it 'cc' do
      expect(Pony.build_mail(cc: 'joe@example.com').cc)
        .to eq(['joe@example.com'])
    end

    it 'reply_to' do
      expect(Pony.build_mail(reply_to: 'joe@example.com').reply_to)
        .to eq(['joe@example.com'])
    end

    it 'cc with multiple recipients' do
      expect(Pony.build_mail(cc: 'joe@example.com, friedrich@example.com').cc)
        .to eq(['joe@example.com', 'friedrich@example.com'])
    end

    it 'from' do
      expect(Pony.build_mail(from: 'joe@example.com').from)
        .to eq(['joe@example.com'])
    end

    it 'bcc' do
      expect(Pony.build_mail(bcc: 'joe@example.com').bcc)
        .to eq(['joe@example.com'])
    end

    it 'bcc with multiple recipients' do
      bcc = 'joe@example.com, friedrich@example.com'
      expect(Pony.build_mail(bcc: bcc).bcc)
        .to eq(['joe@example.com', 'friedrich@example.com'])
    end

    it 'charset' do
      mail = Pony.build_mail(charset: 'UTF-8')
      expect(mail.charset).to eq 'UTF-8'
    end

    it 'text_part_charset' do
      mail = Pony.build_mail(attachments: { 'foo.txt' => 'content of foo.txt' },
                             body: 'test', text_part_charset: 'ISO-2022-JP')

      expect(mail.text_part.charset).to eq 'ISO-2022-JP'
    end

    it 'default charset' do
      expect(Pony.build_mail(body: 'body').charset).to eq 'UTF-8'
      expect(Pony.build_mail(html_body: 'body').charset).to eq 'UTF-8'
    end

    it 'from (default)' do
      expect(Pony.build_mail({}).from).to eq ['pony@unknown']
    end

    it 'subject' do
      expect(Pony.build_mail(subject: 'hello').subject).to eq('hello')
    end

    it 'body' do
      expect(Pony.build_mail(body: 'What do you know, Joe?').body)
        .to eq('What do you know, Joe?')
    end

    it 'html_body' do
      html_body =  'What do you know, Joe?'
      expect(Pony.build_mail(html_body: html_body).parts.first.body)
        .to eq html_body
      expect(Pony.build_mail(html_body: html_body).parts.first.content_type)
        .to eq 'text/html; charset=UTF-8'
    end

    it 'content_type' do
      expect(Pony.build_mail(content_type: 'multipart/related').content_type)
        .to eq 'multipart/related'
    end

    it 'date' do
      now = Time.now
      expect(Pony.build_mail(date: now).date).to eq DateTime.parse(now.to_s)
    end

    it 'message_id' do
      expect(Pony.build_mail(message_id: '<abc@def.com>').message_id)
        .to eq 'abc@def.com'
    end

    it 'custom headers' do
      mail = Pony.build_mail(headers: { 'List-ID' => '<abc@def.com>' })
      expect(mail['List-ID'].to_s).to eq '<abc@def.com>'
    end

    it 'sender' do
      expect(Pony.build_mail(sender: 'abc@def.com')['Sender'].to_s)
        .to eq('abc@def.com')
    end

    it 'utf-8 encoded subject line' do
      body = 'body body body'
      mail = Pony.build_mail(to: 'btp@foo', subject: 'Café', body: body)
      expect(mail['subject'].encoded).to match(/^Subject: =\?UTF-8/)
    end

    it 'attachments' do
      mail = Pony.build_mail attachments: { 'foo.txt' => 'content of foo.txt' },
                             body: 'test'

      expect(mail.parts.length).to eq 2
      expect(mail.parts.first.to_s).to match(%r{Content-Type: text/plain})
      expect(mail.attachments.first.content_id)
        .to eq("<foo.txt@#{Socket.gethostname}>")
    end

    it 'suggests mime-type' do
      mail = Pony.build_mail(attachments: { 'foo.pdf' => 'content of foo.pdf' })
      expect(mail.parts.length).to eq 1
      expect(mail.parts.first.to_s).to match(%r{Content-Type: application/pdf})
      expect(mail.parts.first.to_s).to match(/filename=foo.pdf/)
      expect(mail.parts.first.content_transfer_encoding.to_s).to eq('base64')
    end

    it 'encodes xlsx files as base64' do
      xslx = 'content of foo.xlsx'
      mail = Pony.build_mail(attachments: { 'foo.xlsx' => xslx })
      expect(mail.parts.length).to eq 1
      expect(mail.parts.first.to_s).to match(%r{Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet})
      expect(mail.parts.first.to_s).to match(/filename=foo.xlsx/)
      expect(mail.parts.first.content_transfer_encoding.to_s).to eq 'base64'
    end

    it 'passes cc and bcc as the list of recipients' do
      mail = Pony.build_mail to: ['to'], cc: ['cc'], from: ['from'],
                             bcc: ['bcc']
      expect(mail.destinations).to eq(%w(to cc bcc))
    end
  end

  describe 'additional headers' do
    subject(:mail) do
      Pony.build_mail(
        body: 'test',
        html_body: 'What do you know, Joe?',
        attachments: { 'foo.txt' => 'content of foo.txt' },
        body_part_header: { content_disposition: 'inline' },
        html_body_part_header: { content_disposition: 'inline' }
      )
    end

    it { expect(mail.parts[0].parts[0].to_s).to include('inline') }
    it { expect(mail.parts[0].parts[1].to_s).to include('inline') }

    context "when parts aren't present" do
      subject(:mail) do
        Pony.build_mail(
          body: 'test',
          body_part_header: { content_disposition: 'inline' },
          html_body_part_header: { content_disposition: 'inline' }
        )
      end

      it { expect(mail.parts).to be_empty }
      it { expect(mail.to_s).to_not include('inline') }
    end
  end

  describe 'content type' do
    context 'mail with attachments, html_body and body ' do
      subject(:mail) do
        Pony.build_mail(
          body: 'test',
          html_body: 'What do you know, Joe?',
          attachments: { 'foo.txt' => 'content of foo.txt' }
        )
      end

      it { expect(mail.parts.length).to eq 2 }
      it { expect(mail.parts[0].parts.length).to eq 2 }
      it { expect(mail.content_type.to_s).to include('multipart/mixed') }
      it { expect(mail.parts[0].content_type.to_s).to include('multipart/alternative') }
      it { expect(mail.parts[0].parts[0].to_s).to include('Content-Type: text/html') }
      it { expect(mail.parts[0].parts[1].to_s).to include('Content-Type: text/plain') }
      it { expect(mail.parts[1].to_s).to include('Content-Type: text/plain') }
    end
  end

  describe 'transport' do
    describe 'SMTP transport' do
      it 'defaults to localhost as the SMTP server' do
        mail = Pony.build_mail to: 'foo@bar', enable_starttls_auto: true,
                               via: :smtp
        expect(mail.delivery_method.settings[:address]).to eq('localhost')
      end

      it 'enable starttls when tls option is true' do
        mail = Pony.build_mail to: 'foo@bar', enable_starttls_auto: true,
                               via: :smtp

        expect(mail.delivery_method.settings[:enable_starttls_auto]).to eq(true)
      end
    end
  end

  describe ':via option should over-ride the default transport mechanism' do
    it 'should send via sendmail if :via => sendmail' do
      mail = Pony.build_mail(to: 'joe@example.com', via: :sendmail)
      expect(mail.delivery_method).to be_kind_of Mail::Sendmail
    end

    it 'should send via smtp if :via => smtp' do
      mail = Pony.build_mail(to: 'joe@example.com', via: :smtp)
      expect(mail.delivery_method).to be_kind_of Mail::SMTP
    end
  end
end
