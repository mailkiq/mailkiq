module API
  module V1
    class SubscribersController < BaseController
      before_action :authenticate!
    end
  end
end
