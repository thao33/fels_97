class Admin::LessonsController < AdminController
  PER_PAGE = 10
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def index
    @lessons = Lesson.order(created_at: :desc).paginate page: params[:page],
                per_page: PER_PAGE
  end

  def show
  end

  def edit
  end

  def update
    if @lesson.update_attributes lesson_params
      redirect_to admin_lesson_path(@lesson)
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to admin_lessons_path
  end

  private

  def set_lesson
    @lesson = Lesson.find params[:id]
    @lesson_words = @lesson.lesson_words
    @count = @lesson.correct_count @lesson_words
  end

  def lesson_params
    params.require(:lesson).permit(:category_id)
  end
end
