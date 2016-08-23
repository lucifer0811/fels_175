class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def show
    @words = @category.words
  end

  def index
    @q = Category.search(params[:q])
    @categories = @q.result(distinct: true).order("created_at DESC")
      .page(params[:page]).per(Settings.users.per_page)
    @category = Category.new
  end

  def create
    respond_to do |format|
      if @category.save
        format.html {redirect_to admin_categories_path,
          notice: t("controller.categories.notice")}
        format.js
      else
        format.html {render :new}
        format.js
      end
    end
  end

  def edit
  end

  def update
    byebug
    respond_to do |format|
      if @category.update_attributes category_params
        format.html {redirect_to admin_categories_path,
          notice: t("controller.categories.notice")}
        format.js
      else
        format.html {render :edit}
        format.js
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      format.html {redirect_to categories_url,
        notice: t("controller.categories.notice")}
      format.js
    end
  end

  private
  def category_params
    params.require(:category).permit :name, :description, :avatar
  end
end
