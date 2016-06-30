class MarketingController < ApplicationController
  layout false
  force_ssl if: :ssl_configured?

  def index
  end
end
