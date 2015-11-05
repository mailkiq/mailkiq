class ListsController < ApplicationController
  before_action :require_login
  layout 'admin'

  def index
    @lists = current_user.lists
  end

  def show
    @list = current_user.lists.find params[:id]
  end

  def new
    @list = current_user.lists.new
  end

  def create
    @list = current_user.lists.new list_params
    @list.save
    respond_with @list, location: lists_path
  end

  def edit
    @list = current_user.lists.find params[:id]
  end

  def update
    @list = current_user.lists.find params[:id]
    @list.update list_params
    respond_with @list, location: lists_path
  end

  def destroy
    @list = current_user.lists.find params[:id]
    @list.destroy
    respond_with @list
  end

  private

  def list_params
    params.require(:list).permit :name, :double_optin, :confirm_url,
                                 :subscribed_url, :unsubscribed_url, :thankyou,
                                 :thankyou_subject, :thankyou_message, :goodbye,
                                 :goodbye_subject, :goodbye_message,
                                 :confirmation_subject, :confirmation_message,
                                 :unsubscribe_all_list
  end
end
