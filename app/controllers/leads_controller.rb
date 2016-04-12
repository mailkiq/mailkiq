class LeadsController < ApplicationController
  def create
    @account = Account.find_by email: 'rainerborene@gmail.com'

    @subscriber = @account.subscribers.build lead_params
    @subscriber.state = Subscriber.states[:active]
    @subscriber.guess_name!
    @subscriber.save

    respond_with @subscriber, flash_now: false do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  def lead_params
    params.require(:lead).permit :email
  end
end
