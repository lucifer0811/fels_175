class LessonMailer < ApplicationMailer
  def lesson_email user, lesson
    @user = user
    @lesson = lesson
    mail to: @user.email, subject: I18n.t("mail.result.subject")
  end
end
