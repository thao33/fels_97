class Answer < ActiveRecord::Base
  belongs_to :words
  has_many :lesson_words

  scope :correct_answer, -> {where(correct: true)}
end
