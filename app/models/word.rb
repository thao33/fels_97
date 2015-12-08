class Word < ActiveRecord::Base
  ALL_WORDS = 2
  READ_WORDS = 1
  UNREAD_WORDS = 0

  attr_accessor :category_id, :status

  belongs_to :lesson

  class << self
    def generate params
      word = Word.new
      word.category_id = params[:category_id].to_i
      word.status = params[:status] ? params[:status].to_i : ALL_WORDS
      word
    end
  end

  def status_blank?
    status.blank? || (status == ALL_WORDS)
  end
end
