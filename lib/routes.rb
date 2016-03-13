module Routes
  class Base
    include Rails.application.routes.url_helpers

    def default_url_options
      ActionMailer::Base.default_url_options
    end
  end

  def self.method_missing(method, *args, &block)
    @url_helpers ||= Base.new

    if @url_helpers.respond_to?(method)
      @url_helpers.send(method, *args, &block)
    else
      super method, *args, &block
    end
  end
end
