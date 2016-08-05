class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_category, only: [:show]
  def new
    @category = Category.new
  end
  def show
  end
  def index
    @categories = Category.paginate(:per_page => 6, :page => params[:page]).order('created_at DESC')
  end
  private
  def load_category
    @category = Category.find_by id: params[:id]
  end
end
