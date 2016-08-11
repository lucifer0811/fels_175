class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def show
  end

  def index
    @categories = Category.all.order("created_at DESC").page params[:page]
    @category = Category.new
  end

  def create
    respond_to do |format|
      if @category.save
        format.html {redirect_to @category,
          notice: t "controller.categories.notice" }
        format.js
      else
        format.html {render :new}
        format.js
      end
    end
  end

  private
  def category_params
    params.require(:category).permit :name, :description
  end
end
