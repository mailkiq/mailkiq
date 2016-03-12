class DomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if unverified_domain?(record, value)
      record.errors.add attribute, :unverified_domain
    end
  end

  private

  def unverified_domain?(record, value)
    mail = Mail::Address.new(value)
    names = record.send(domains_method_name)
    names.exclude? mail.domain
  end

  def domains_method_name
    options.fetch(:domains, :account_domain_names)
  end
end
