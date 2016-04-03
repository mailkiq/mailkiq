class TagsController < ApplicationController
  before_action :authenticate_account!

  has_scope :page, default: 1

  def index
    @tags = apply_scopes current_account.tags
  end

  def new
    @tag = current_account.tags.new
  end

  def create
    @tag = current_account.tags.new tag_params
    @tag.save
    respond_with @tag, location: tags_path
  end

  def edit
    @tag = current_account.tags.find params[:id]
  end

  def update
    @tag = current_account.tags.find params[:id]
    @tag.update(tag_params)
    respond_with @tag, location: tags_path
  end

  def destroy
    @tag = current_account.tags.find params[:id]
    @tag.destroy
    respond_with @tag, location: tags_path
  end

  private

  def tag_params
    params.require(:tag).permit :name
  end
end
