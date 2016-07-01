require 'mail'
require 'base64'
require 'socket'

module Pony
  def self.non_standard_options
    [:attachments, :body, :charset, :enable_starttls_auto, :headers,
     :html_body, :text_part_charset, :via, :via_options, :body_part_header,
     :html_body_part_header]
  end

  def self.build_mail(options)
    mail = Mail.new do |m|
      options[:date] ||= Time.now
      options[:from] ||= 'pony@unknown'
      options[:via_options] ||= {}

      options.each do |k, v|
        next if Pony.non_standard_options.include?(k)
        m.send(k, v)
      end

      # Automatic handling of multipart messages in the underlying
      # mail library works pretty well for the most part, but in
      # the case where we have attachments AND text AND html bodies
      # we need to explicitly define a second multipart/alternative
      # boundary to encapsulate the body-parts within the
      # multipart/mixed boundary that will be created automatically.
      if options[:attachments] && options[:html_body] && options[:body]
        part(content_type: 'multipart/alternative') do |p|
          p.html_part = Pony.build_html_part(options)
          p.text_part = Pony.build_text_part(options)
        end

      # Otherwise if there is more than one part we still need to
      # ensure that they are all declared to be separate.
      elsif options[:html_body] || options[:attachments]
        m.html_part = Pony.build_html_part(options) if options[:html_body]
        m.text_part = Pony.build_text_part(options) if options[:body]

      # If all we have is a text body, we don't need to worry about parts.
      elsif options[:body]
        body options[:body]
      end

      delivery_method options[:via], options[:via_options]
    end

    (options[:headers] ||= {}).each do |key, value|
      mail[key] = value
    end

    add_attachments(mail, options[:attachments]) if options[:attachments]

    # charset must be set after setting content_type
    mail.charset = options[:charset] if options[:charset]

    if mail.multipart? && options[:text_part_charset]
      mail.text_part.charset = options[:text_part_charset]
    end
    set_content_type(mail, options[:content_type])
    mail
  end

  def self.build_html_part(options)
    Mail::Part.new(content_type: 'text/html;charset=UTF-8') do
      content_transfer_encoding 'quoted-printable'
      body Mail::Encodings::QuotedPrintable.encode(options[:html_body])
      if options[:html_body_part_header] && options[:html_body_part_header].is_a?(Hash)
        options[:html_body_part_header].each do |k, v|
          header[k] = v
        end
      end
    end
  end

  def self.build_text_part(options)
    Mail::Part.new(content_type: 'text/plain') do
      content_type options[:charset] if options[:charset]
      body options[:body]
      if options[:body_part_header] && options[:body_part_header].is_a?(Hash)
        options[:body_part_header].each do |k, v|
          header[k] = v
        end
      end
    end
  end

  def self.set_content_type(mail, user_content_type)
    params = mail.content_type_parameters || {}
    content_type = case
                   when user_content_type
                     user_content_type
                   when mail.has_attachments?
                     if mail.attachments.detect(&:inline?)
                       ['multipart', 'related', params]
                     else
                       ['multipart', 'mixed', params]
                     end
                   when mail.multipart?
                     ['multipart', 'alternative', params]
                   else
                     false
                   end
    mail.content_type = content_type if content_type
  end

  def self.add_attachments(mail, attachments)
    attachments.each do |name, body|
      name = name.gsub(/\s+/, ' ')

      # mime-types wants to send these as "quoted-printable"
      if name =~ /\.xlsx$/
        mail.attachments[name] = {
          content: Base64.encode64(body),
          transfer_encoding: :base64
        }
      else
        mail.attachments[name] = body
      end
      mail.attachments[name].add_content_id("<#{name}@#{Socket.gethostname}>")
    end
  end
end
