# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create categories
categories = ["Basic", "Advance", "On a trip"]

categories.each do |category|
  Category.create(name: category, description: "All about #{category}")
end

# Create lessons
categories = Category.all

categories.each do |category|
  10.times do |i|
    Lesson.create(category_id: category.id, name: "Lesson #{i}", description: "All about Lesson #{i}")
  end
end


# Create 10 words each lesson
lessons = Lesson.all
lesson_first_words = {
  "ありがとう" => "cảm ơn",
  "きれい" => "đẹp",
  "あおい" => "màu xanh",
  "しろい" => "màu trắng",
  "くうきいれ" => "cái bơm",
  "おかあさん" => "mẹ",
  "おにいさん" => "anh",
  "おとうさん" => "bố",
  "いもうと" => "em gái",
  "えき" => "nhà ga",
  "こうえん" => "công viên",
  "バイク" => "xe đạp",
  "にほん" => "Nhật Bản",
  "すばらしい" => "tuyệt vời",
  "ごめん" => "xin lỗi",
  "にく" => "thịt",
  "やさい" => "rau",
  "ともだち" => "bạn",
  "こいびと" => "người yêu",
  "さくら" => "hoa anh đào",
}

lessons.each do |lesson|
  lesson_first_words.each do |k, v|
    Word.create(ja: k, vn: v, lesson_id: lesson.id)
  end
end