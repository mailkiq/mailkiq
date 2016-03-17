class TagsController < ApplicationController
  before_action :require_login

  has_scope :page, default: 1

  def index
    @tags = apply_scopes current_user.tags
  end

  def new
    @tag = current_user.tags.new
  end

  def create
    @tag = current_user.tags.new tag_params
    @tag.save
    respond_with @tag, location: tags_path
  end

  def edit
    @tag = current_user.tags.find params[:id]
  end

  def update
    @tag = current_user.tags.find params[:id]
    @tag.update(tag_params)
    respond_with @tag, location: tags_path
  end

  private

  def tag_params
    params.require(:tag).permit :name
  end
end
