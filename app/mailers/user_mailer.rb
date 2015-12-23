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
end
