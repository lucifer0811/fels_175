class LessonMailer < ApplicationMailer

  def lesson_finished_email lesson
    @user = lesson.user
    @lesson = lesson
    mail to: @user.email, subject: I18n.t("mail.result.subject")
  end

  def monthly_email user, wordcount
    @wordcount = wordcount
    @user = user
    mail to: @user.email, subject: I18n.t("mail.monthly.subject")
  end

  def remind_email lesson
    @user = lesson.user
    @lesson = lesson
    mail to: @user.email, subject: I18n.t("mail.remind.subject")
  end
end
