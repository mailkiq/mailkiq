module Query
  module_function

  def select_all(sql, *opts)
    options = opts.extract_options!
    name = options[:name] || sql.to_s.humanize
    ActiveRecord::Base.connection.select_all prepare(sql, *opts), name
  end

  def execute(sql, *opts)
    options = opts.extract_options!
    name = options[:name] || sql.to_s.humanize
    ActiveRecord::Base.connection.execute prepare(sql, *opts), name
  end

  def prepare(sql, options = {})
    statement = File.read("db/queries/#{sql}.sql")
    statement.gsub!(/:([a-zA-Z]\w*)/) do |bind_variable|
      options.fetch bind_variable.tr(':', '').to_sym
    end if options.present?
    statement.squish!
  end
end
