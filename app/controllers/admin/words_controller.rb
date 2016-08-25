class Admin::WordsController < ApplicationController
  load_and_authorize_resource

  def new
    @word = Word.new
    Settings.word.number.times {@word.answers.build}
  end

  def create
    @word = Word.new word_params
    @word.category = Category.find_by id: params[:category_id]
    if @word.save
      flash[:success] = t "controller.words.create_success"
      redirect_to admin_category_path(@word.category)
    else
      flash[:danger] = @word.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t "flash.success"
      redirect_to admin_category_path(@word.category)
    else
      flash[:danger] = t "flash.fail"
      render :edit
    end
  end

  def destroy
    unless @word.results.any?
      if @word.destroy
        flash[:success] = t "controller.words.notice"
      else
        flash[:danger] = t "controller.words.fail"
      end
    else
      flash[:notice] = t "controller.words.exsist"
    end
    redirect_to :back
  end

  private
  def word_params
    params.require(:word).permit(:id, :content,
      answers_attributes: [:id, :word_id, :content, :is_correct])
  end
end
