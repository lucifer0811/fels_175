class LessonWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform lesson_id
    target = Lesson.find_by id: lesson_id
    LessonMailer.lesson_finished_email(target).deliver_now
  end
end

