namespace :counter_cache do
  desc 'Update campaigns counter cache columns'
  task update: :environment do
    sql = File.readlines('db/queries/counter_cache.sql').join
    ActiveRecord::Base.connection.execute(sql)
  end
end
