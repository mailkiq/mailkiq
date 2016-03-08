class MarketingController < ApplicationController
  http_basic_authenticate_with name: 'mkq', password: 'mkq'

  layout false

  def index
  end
end
