module Query
  module_function

  def select_all(filename)
    sql = File.read("db/queries/#{filename}.sql")
    ActiveRecord::Base.connection.execute(sql)
  end

  def execute(filename)
    sql = File.read("db/queries/#{filename}.sql")
    ActiveRecord::Base.connection.select_all(sql)
  end
end
