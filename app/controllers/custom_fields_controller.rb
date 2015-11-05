class CustomFieldsController < ApplicationController
  before_action :require_login
  before_action :set_list
  layout 'admin'

  def index
    @custom_fields = @list.custom_fields
  end

  def new
    @custom_field = @list.custom_fields.new
  end

  def create
    @custom_field = @list.custom_fields.new custom_field_params
    @custom_field.save
    respond_with @custom_field, location: list_custom_fields_path(@list)
  end

  private

  def set_list
    @list = current_user.lists.find params[:list_id]
  end

  def custom_field_params
    params.require(:custom_field).permit :field_name, :data_type,
                                         :field_options, :hidden
  end
end
