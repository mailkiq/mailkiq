class MarketingController < ApplicationController
  http_basic_authenticate_with name: 'mkq', password: 'mkq'

  def index
  end
end
