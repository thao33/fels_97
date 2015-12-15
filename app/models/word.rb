class Word < ActiveRecord::Base
  ALL_WORDS = 2
  LEARNED_WORDS = 1
  NOT_LEARNED_WORDS = 0
  BY_LESSON_QUERY = "(lesson_id in
    (SELECT id from lessons
    where user_id = :user_id))"
  LEARNED_WORDS_QUERY = "id in
    (SELECT word_id from lesson_words
    where #{BY_LESSON_QUERY}
    and answer_id IS NOT NULL)"

  belongs_to :category
  has_many :answers, dependent: :destroy
  has_many :lesson_words, dependent: :destroy
  accepts_nested_attributes_for :answers, limit: 4

  validates :ja, presence: true

  scope :by_category, ->(category_id){where category_id: category_id}
  scope :learned, ->(user_id){where LEARNED_WORDS_QUERY, user_id: user_id}
  scope :not_learned, ->(user_id){where.not(LEARNED_WORDS_QUERY, user_id: user_id)}

  class << self
    def all_status
      {
        NOT_LEARNED_WORDS => "not learned",
        LEARNED_WORDS => "learned",
        ALL_WORDS => "all"
      }
    end

    def search params, current_user
      unless self.filter_by_status? params[:status]
        Word.by_category params[:category]
      else
        key = self.generate_key params[:status]
        Word.by_category(params[:category]).send(key, current_user)
      end
    end

    def generate_key status
      status.to_i == LEARNED_WORDS ? "learned" : "not_learned"
    end

    def filter_by_status? status
      status and status.to_i != ALL_WORDS
    end

    def not_learned_category category_id, user_id
      self.by_category(category_id).send("not_learned", user_id)
    end
  end

  def correct_answer
    answers.correct_answer.first.answer
  end
end
