module ControllerHelpers
  def sign_in(account = double('account'))
    if account.nil?
      allow(request.env['warden']).to receive(:authenticate!)
        .and_throw(:warden, scope: :account)

      allow(controller).to receive(:current_account).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(account)
      allow(controller).to receive(:current_account).and_return(account)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
end
