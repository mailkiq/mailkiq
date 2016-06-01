module Query
  module_function

  def select_all(name, options = {})
    tag = options[:name] || name.to_s.humanize
    ActiveRecord::Base.connection.select_all prepare(name, options), tag
  end

  def execute(name, options = {})
    tag = options[:name] || name.to_s.humanize
    ActiveRecord::Base.connection.execute prepare(name, options), tag
  end

  def prepare(name, options = {})
    statement = File.read("db/queries/#{name}.sql")
    statement.gsub!(/:([a-zA-Z]\w*)/) do |bind_variable|
      options.fetch bind_variable.tr(':', '').to_sym
    end if options.present?
    statement.squish!
  end
end
