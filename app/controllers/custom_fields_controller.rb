class CustomFieldsController < ApplicationController
  before_action :require_login
  before_action :set_list
  before_action :set_custom_fields, except: [:destroy]
  layout 'admin'

  def index
    @custom_field = @list.custom_fields.new
  end

  def edit
    @custom_field = @list.custom_fields.find params[:id]
  end

  def update
    @custom_field = @list.custom_fields.find params[:id]
    @custom_field.update custom_field_params
    respond_with @custom_field, location: list_custom_fields_path(@list)
  end

  def create
    @custom_field = @list.custom_fields.new custom_field_params
    @custom_field.save
    respond_with @custom_field, location: list_custom_fields_path(@list) do |format|
      format.html { render :index } unless @custom_field.valid?
    end
  end

  def destroy
    @custom_field = @list.custom_fields.find params[:id]
    @custom_field.destroy
    respond_with @custom_field, location: list_custom_fields_path(@list)
  end

  private

  def set_list
    @list = current_user.lists.find params[:list_id]
  end

  def set_custom_fields
    @custom_fields = @list.custom_fields.all
  end

  def custom_field_params
    params.require(:custom_field).permit :field_name, :data_type, :hidden
  end
end
