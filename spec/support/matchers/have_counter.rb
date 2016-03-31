RSpec::Matchers.define :have_counter do |expected|
  match do |actual|
    include_redis_objects?(actual) && include_counter?(actual)
  end

  failure_message do |actual|
    "expected #{actual.class} class to create counter :#{expected}"
  end

  def include_counter?(actual)
    redis_objects = actual.class.redis_objects
    redis_objects.key?(expected) && redis_objects[expected][:type] == :counter
  end

  def include_redis_objects?(actual)
    actual.class.ancestors.include? Redis::Objects
  end
end
