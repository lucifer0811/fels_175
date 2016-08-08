class Admin::CategoriesController < ApplicationController
  before_action :load_category, only: [:show]

  def new
    @category = Category.new
  end

  def show
  end

  def index
    @categories = Category.all.order("created_at DESC").page params[:page]
  end

  private
  def load_category
    @category = Category.find_by id: params[:id]
    unless @category
      flash[:danger] = t "views.flash.object_nil"
      redirect_to admin_categories_path
    end
  end
end
