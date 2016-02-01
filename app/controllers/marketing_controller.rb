class MarketingController < ApplicationController
  http_basic_authenticate_with name: 'rainer', password: 'secret'

  def index
  end
end
