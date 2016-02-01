class SubscribersController < AdminController
  respond_to :html, :json

  def index
    @subscribers = current_user.subscribers
  end

  def new
    @subscriber = current_user.subscribers.new
  end

  def create
    @subscriber = current_user.subscribers.create subscriber_params
    respond_with @subscriber, location: subscribers_path
  end

  def edit
    @subscriber = current_user.subscribers.find params[:id]
  end

  def update
    @subscriber = current_user.subscribers.find params[:id]
    @subscriber.update subscriber_params
    respond_with @subscriber, location: subscribers_path
  end

  def destroy
    @subscriber = current_user.subscribers.find params[:id]
    @subscriber.destroy
    respond_with @subscriber, location: subscribers_path
  end

  private

  def subscriber_params
    params.require(:subscriber).permit :name, :email
  end
end
