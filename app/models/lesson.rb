class Lesson < ActiveRecord::Base
  QUESTION_BLOCK = 20
  belongs_to :user
  belongs_to :category
  has_many :lesson_words

  after_create :create_lesson_words
  scope :monthly, ->(user_id, start_of_month, end_of_month){
                    where created_at: start_of_month..end_of_month,
                    user_id: user_id}

  def create_lesson_words
    words = Word.not_learned_category self.category_id, self.user_id
    QUESTION_BLOCK.times do |n|
      word_id = words[rand(words.count)]
      LessonWord.create! lesson_id: self.id, word_id: word_id.id
    end
  end

  def correct_count lesson_words
    count = 0
    lesson_words.map do |word|
      count += 1 unless word.answer.nil? or !word.answer.correct
    end
    count
  end

  def category_name
    category.name
  end
end