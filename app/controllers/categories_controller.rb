class CategoriesController < ApplicationController
  load_and_authorize_resource

  def show
  end

  def index
    @categories = Category.all.order("created_at DESC").page params[:page]
  end
end
