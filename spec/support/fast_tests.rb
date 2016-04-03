RSpec.configure do |config|
  config.before :each do
    allow_any_instance_of(ActiveRecord::Validations::UniquenessValidator)
      .to receive(:validate_each)
  end
end
