class LessonMailer < ApplicationMailer
  def lesson_email user, lesson
    @user = user
    @lesson = lesson
    mail to: @user.email, subject: I18n.t("mail.result.subject")
  end

  def monthly_email user, wordcount
    @wordcount = wordcount
    @user = user
    mail to: @user.email, subject: I18n.t("mail.monthly.subject")

  def remind_email user, lesson
    @user = user
    @lesson = lesson
    mail to: @user.email, subject: I18n.t("mail.remind.subject")
  end
end
