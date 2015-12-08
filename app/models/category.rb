class Category < ActiveRecord::Base
  has_many :lessons
end
