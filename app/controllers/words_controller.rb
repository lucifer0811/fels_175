class WordsController < ApplicationController
  load_and_authorize_resource

  def index
    @categories = Category.all
    params[:word_filter] ||= Settings.word_filter[:all]
    @words = Word.in_category(params[:category_id])
      .send(params[:word_filter], current_user.id)
      .page(params[:page]).per Settings.words.per_page
    @index = params[:page].nil? ? 0 :
      ((params[:page].to_i - 1) * (Settings.words.per_page))
  end
end
