module CronTask
  class << self
    def statistic_exams
      users = User.all
      users.each do |user|
        UserMailer.statistic_exams_notify(user).deliver_now
      end
    end
  end
end