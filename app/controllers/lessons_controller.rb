class LessonsController < ApplicationController
  before_action :load_data, except: [:new, :create]

  def new
  end

  def create
    category_id = params[:lesson][:category_id]
    lesson = Lesson.new(category_id: category_id, user_id: current_user.id)
    Delayed::Job.enqueue ExamNotStart.new(current_user) , 0, 8.hours.from_now unless lesson.created_at
    if lesson.save
      redirect_to lesson_path(lesson)
    else
      redirect_to categories_path
    end
  end

  def show
    if params[:type] == "result"
      @count = @lesson.correct_count @lesson_words
      @show_result = true
    else
      @word = @lesson_words.first
      @word_number = 0
    end
  end

  def update
    check_true_false
    end_lesson_condition
    render_next_word

    respond_to do |format|
      format.js
    end
  end

  private

  def load_data
    id = params[:type] == "result" ? params[:lesson_id] : params[:id]
    @lesson = Lesson.find id
    @lesson_words = @lesson.lesson_words
  end

  # Check the lesson be finish or not. If finish => show the result
  # of lesson (by @show_result variable, if true => show the result)
  def end_lesson_condition
    @check_word_number = params[:word_number].to_i + 1
    @show_result = @check_word_number == Lesson::QUESTION_BLOCK

    # Show the proress if show the result
    @count = @lesson.correct_count @lesson_words if @show_result
    @word_number = @check_word_number
  end

  # Get the next word and it's answers.
  def render_next_word
    @next_word = @lesson_words[params[:word_number].to_i]
    @answers = @next_word.answers
    @index = params[:answer_index]
  end

  # Check the answer is true of false, then update
  # answer_id of lesson_words table.
  def check_true_false
    @answer = Answer.find params[:answer_id]
    flag = @answer.correct

    word = LessonWord.find params[:word_id]
    word.update_attributes! answer_id: @answer.id
    if flag
      @class = I18n.t "lesson.check.class.success"
      @message = I18n.t "lesson.check.message.success"
    else
      @class = I18n.t "lesson.check.class.failed"
      @message = I18n.t "lesson.check.message.failed"
    end
  end
end
