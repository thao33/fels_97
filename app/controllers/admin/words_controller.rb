class Admin::WordsController < AdminController
  PER_PAGE = 20
  before_action :set_word, only: [:show, :edit, :destroy, :update]

  def index
    @words = Word.order(updated_at: :desc).paginate page: params[:page], per_page: PER_PAGE
  end

  def show
  end

  def new
    @word = Word.new
    4.times {@word.answers.build}
    @categories = Category.all
  end

  def create
    @word = Word.new word_params
    if @word.save
      redirect_to admin_word_path(@word)
    else
      flash[:danger] = I18n.t "admin.errors.blank"
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes word_params_update
      redirect_to admin_word_path(@word)
    else
      flash[:danger] = I18n.t "admin.errors.blank"
      render :edit
    end
  end

  def destroy
    @word.destroy
    redirect_to admin_words_path
  end

  private

  def set_word
    @word = Word.find params[:id]
  end

  def word_params
    params.require(:word).permit(:ja, :category_id, answers_attributes: [:answer, :correct])
  end

  def word_params_update
    params.require(:word).permit(:ja, :category_id, answers_attributes: [:answer, :correct, :id])
  end
end