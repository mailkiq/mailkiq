require 'ostruct'
require 'csv'

class Import
  class Row < OpenStruct
    delegate :error, :success?, to: :@importer
    delegate :except, to: :@table

    def initialize(attributes, importer)
      @importer = importer
      super(attributes)
    end

    def valid?
      error :invalid_email, email: email unless EmailValidator.valid? email
      error :name_blank unless name.present?
      success?
    end
  end

  include ActiveModel::Model

  attr_accessor :text
  attr_accessor :file
  attr_accessor :list

  def process
    parse! text || file
    read_rows

    return false unless success?

    @rows.each do |row|
      record = Subscriber.find_or_initialize_by email: row.email, account_id: list.account_id
      record.name = row.name
      record.custom_fields.merge! row.except(:name, :email)
      record.save!
      list.subscribe! record
    end
  end

  def success?
    errors.empty?
  end

  def error(key, options = {})
    errors.add :base, key, options.merge(lineno: @csv.lineno)
  end

  private

  def custom_fields
    @custom_fields ||= list.custom_fields.to_a.tap do |collection|
      collection << CustomField.new(key: 'name', field_name: 'Name')
      collection << CustomField.new(key: 'email', field_name: 'E-mail')
    end
  end

  def find_header_by_name!(name)
    custom_fields.find { |custom_field| custom_field.match? name }
  end

  def read_rows
    @rows = @csv.read.map do |row|
      record = Row.new(row.to_hash, self)
      return false unless record.valid?
      record
    end
  end

  def parse!(data)
    @csv = CSV.new data, headers: true
    @csv.header_convert do |field, _|
      header = find_header_by_name! field
      error :unknown_column, name: field unless header
      header ? header.key : field
    end
  end
end
