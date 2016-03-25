RSpec::Matchers.define :have_attr_accessor do |expected|
  match do |actual|
    actual.respond_to?(expected) && actual.respond_to?("#{expected}=")
  end
end
