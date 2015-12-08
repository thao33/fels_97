class Category < ActiveRecord::Base
  has_many :lessons

  def words
    words = []
    lessons.each {|lesson| words += lesson.words }
    words.slice(0,20)
  end
end
