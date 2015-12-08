class WordsController < ApplicationController
  PER_PAGE = 24

  def index
    @words = Word.paginate(page: params[:page], per_page: PER_PAGE)
    @word_group1 = @words.slice(0,PER_PAGE/2)
    @word_group2 = @words.slice(PER_PAGE/2,PER_PAGE)
    @word = params[:commit].blank? ? Word.new : Word.generate(params[:word])
  end
end