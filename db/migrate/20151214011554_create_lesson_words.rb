class CreateLessonWords < ActiveRecord::Migration
  def change
    create_table :lesson_words do |t|
      t.references :lesson, index: true, foreign_key: true
      t.references :word, index: true, foreign_key: true
      t.references :answer, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end