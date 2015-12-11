class Category < ActiveRecord::Base
  has_many :words
  has_many :lessons
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
end
