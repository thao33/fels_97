class UserMailer < ApplicationMailer

  def new_category_notify user, category
    @user = user
    @category = category
    mail to: user.email, subject: I18n.t("mailers.subjects.new_category_notify")
  end

  def created_exam_not_start_notify user
    @user = user
    mail to: user.email, subject: I18n.t("mailers.subjects.created_exam_not_start_notify")
  end

  def statistic_exams_notify user
    @user = user
    @exams = user.monthly_exams
    mail to: user.email, subject: I18n.t("mailers.subjects.statistic_exams_notify")
  end
end
