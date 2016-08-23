class LessonsController < ApplicationController
  before_action :load_lesson, only: [:edit, :update, :show]
  before_action :completed_lesson, only: [:edit, :update]
  before_action :incompleted_lesson, only: :show
  load_and_authorize_resource

  def show
  end

  def create
    @lesson = current_user.lessons.new lesson_params
    if @lesson.save
      redirect_to edit_lesson_path @lesson
    else
      flash[:error] = @lesson.error
      redirect_to :back
    end
  end

  def edit
  end

  def update
    completed_lesson_params = lesson_params
    completed_lesson_params[:is_completed] = true
    if @lesson.update_attributes completed_lesson_params
      flash[:success] = t "controllers.lessons.flash.success.finish"
      @lesson.create_activity :create, owner: current_user
      redirect_to lesson_path @lesson
    else
      flash[:danger] = t "controllers.lessons.flash.danger.finish"
      redirect_to edit_lesson_path @lesson
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

  def completed_lesson
    if @lesson.is_completed?
      flash[:info] = t "lessons.finished"
      redirect_to lesson_path @lesson
    end
  end

  def incompleted_lesson
    unless @lesson.is_completed?
      flash[:danger] = t "lessons.require_finish"
      redirect_to edit_lesson_path @lesson
    end
  end

  def lesson_params
    params.require(:lesson).permit :category_id, results_attributes: [:id, :answer_id]

  end
end
