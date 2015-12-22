class NewCategoryNotifyService

  def initialize category
    @users = User.all
    @category = category
  end

  def notify
    @users.each do |user|
      UserMailer.new_category_notify(user, @category).delivery_now
    end
  end
end