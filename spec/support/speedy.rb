RSpec.configure do |config|
  config.before :each, type: :model do
    allow_any_instance_of(ActiveRecord::Validations::UniquenessValidator)
      .to receive(:validate_each)
  end
end
