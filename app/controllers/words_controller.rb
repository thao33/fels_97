class WordsController < ApplicationController
  PER_PAGE = 24

  def index
    setup_for_filter_box params
    if params[:commit].blank?
      @words = Word.paginate(page: params[:page], per_page: PER_PAGE)
    else
      @words = Word.search(params, current_user).paginate(page: params[:page], per_page: PER_PAGE)
    end
    @word_group1 = @words.slice(0,PER_PAGE/2)
    @word_group2 = @words.slice(PER_PAGE/2,PER_PAGE)
  end

  private
  def setup_for_filter_box params
    @categories = Category.all
    @all_status = Word.all_status
    @status = params[:status] ||= Word::ALL_WORDS
    @category = params[:category]
  end
end