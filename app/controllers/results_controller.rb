class ResultsController < ApplicationController
  before_action :load_result, only: :update

  def update
    if @result.is_complete?
      @result.create_activity :create, owner: current_user
    end
  end

  private
  def load_result
    @result = Result.find_by id: params[:id]
    unless @result
      flash[:danger] = t "result.not_found"
      redirect_to root_path
    end
  end
end
