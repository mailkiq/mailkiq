class ImportsController < ApplicationController
  before_action :require_login
  before_action :find_list
  layout 'admin'

  def new
    @import = Import.new
  end

  def create
    @import = Import.new import_params
    @import.list = @list
    @import.process
    respond_with @import, location: new_list_import_path(@list)
  end

  private

  def find_list
    @list = current_user.lists.find params[:list_id]
  end

  def import_params
    params.require(:import).permit :text, :file
  end
end
