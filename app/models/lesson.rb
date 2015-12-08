class Lesson < ActiveRecord::Base
  has_many :words
  belongs_to :category
end