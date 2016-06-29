class ImportsController < ApplicationController
  before_action :authenticate_account!

  def new
  end

  def create
    importer = SubscriberImporter.new current_account
    importer.process! import_params[:csv]
    redirect_to new_import_path
  end

  private

  def import_params
    params.require(:import).permit(:csv)
  end
end
