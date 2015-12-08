# Create users
10.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = "secret"
  User.create! name: name, email: email, password: password, password_confirmation: password
end

# Create categories
categories = ["Basic", "Advance", "On a trip"]

categories.each do |category|
  Category.create! name: category, description: "All about #{category}"
end

# Create lessons
categories = Category.all
users = User.all

categories.each do |category|
  users.each do |user|
    Lesson.create! category_id: category.id, user_id: user.id
  end
end

# Create words
words_paragraph = "週明け日の東京商品取引所は、世界的に原油の供給が需要を大幅に上回る状態が続くという見方から先物に売り注文が集まり、原油の先物価格は一時、およそか月ぶりの安値水準まで下落しました。"
words = words_paragraph.split("")
answers_paragraph = "週明け日の東京商品取引所は、世界的に原油の供給が需要を大幅に上回る状態が続くという見方から先物に売り注文が集まり、原油の先物価格は一時、およか月ぶりの安値水準まで下落しました。"
answers = answers_paragraph.split("")

words.each do |word|
  random_cat = rand(Category.count)
  category_id = random_cat == 0 ? 1 : random_cat
  Word.create! ja: word, category_id: category_id
end

# Create answers
words = Word.all
words.each do |word|
  4.times do |n|
    Answer.create! word_id: word.id, answer: answers[rand(answers.size)], correct: false
  end
end

# Create correct answer
words.each do |word|
  rand_index = rand(word.answers.count)
  answer = word.answers[rand_index]
  answer.update_attributes! correct: true
end

# Create lesson_words records
lessons = Lesson.where user_id: 1..3, category_id: 1...3


lessons.each do |lesson|
  category = lesson.category
  words = category.words
  10.times.each do |n|
    rand = rand(words.count).to_i
    word = words[rand]
    answers = word.answers
    answer = answers[rand(answers.count)]
    LessonWord.create! lesson_id: lesson.id, word_id: word.id, answer_id: answer.id
  end
end