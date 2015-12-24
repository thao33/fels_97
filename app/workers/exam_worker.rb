class ExamWorker
  include Sidekiq::Worker

  def perform user_id, lesson_id
    @lesson = Lesson.find lesson_id
    @user = User.find user_id
    UserMailer.send_exam_result_when_finish(@user, @lesson).deliver_now
  end
end