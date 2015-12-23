class ExamNotStart < Struct.new(:user)
  def perform
    UserMailer.created_exam_not_start_notify(user).deliver
  end
end