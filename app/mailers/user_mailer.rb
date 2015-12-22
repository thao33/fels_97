class UserMailer < ApplicationMailer

  def new_category_notify user, category
    @user = user
    @category = category
    mail to: user.email, subject: I18n.t "mailers.subjects.new_category_notify"
  end
end
