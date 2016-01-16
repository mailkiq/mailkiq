class TemplatesController < ApplicationController
  before_action :require_login
  layout 'admin'

  def index
    @templates = current_user.templates
  end

  def new
    @template = current_user.templates.new
  end

  def create
    @template = current_user.templates.new template_params
    @template.save
    respond_with @template, location: templates_path
  end

  def edit
    @template = current_user.templates.find params[:id]
  end

  def update
    @template = current_user.templates.find params[:id]
    @template.update template_params
    respond_with @template, location: templates_path
  end

  def destroy
    @template = current_user.templates.find params[:id]
    @template.destroy
    respond_with @template, location: templates_path
  end

  private

  def template_params
    params.require(:template).permit :name, :html_text
  end
end
