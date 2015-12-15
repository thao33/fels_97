class Admin::WordsController < AdminController
  PER_PAGE = 20
  before_action :get_word, only: [:show, :edit, :destroy, :update]

  def index
    @words = Word.paginate page: params[:page], per_page: PER_PAGE
  end

  def show
  end

  def new
  end

  def edit
    @categories = Category.all
  end

  def update
    @word.update_word_and_answers params
    redirect_to admin_word_path(@word)
  end

  def destroy
    @word.destroy
  end

  private

  def get_word
    @word = Word.find params[:id]
  end
end
