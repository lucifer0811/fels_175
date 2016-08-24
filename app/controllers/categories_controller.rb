class CategoriesController < ApplicationController
  load_and_authorize_resource

  def show
    @words = @category.words
  end

  def index
    @q = Category.search params[:q]
    @categories = @q.result(distinct: true).order("created_at DESC")
      .page(params[:page]).per Settings.categories.per_page
  end
end
