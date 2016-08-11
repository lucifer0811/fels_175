class LessonsController < ApplicationController
  before_action :load_lesson, only: :update

  def update
    if @lesson.is_complete?
      @lesson.create_activity :create, owner: current_user
      LessonWorker.perform_async current_user, @lesson
    end
  end

  private
  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    unless @lesson
      flash[:danger] = t "lesson.not_found"
      redirect_to root_path
    end
  end
end
