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
    else
      flash[:danger] = t "controller.words.create_fail"
    end
    redirect_to admin_category_path(@word.category)
  end

  private
  def word_params
    params.require(:word).permit(:content,
      answers_attributes: [:word_id, :content, :is_correct])
  end
end
