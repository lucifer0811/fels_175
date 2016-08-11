class LessonWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform user, lesson
    LessonMailer.lesson_email(user, lesson).deliver
  end
end

