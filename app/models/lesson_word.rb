class LessonWord < ActiveRecord::Base
  DELAY_TIME = 500

  belongs_to :lesson
  belongs_to :word
  belongs_to :answer

  def ja
    word.ja
  end

  def answers
    word.answers
  end

  def correct_answer
    word.correct_answer
  end
end
