class CategoriesController < ApplicationController
  PER_PAGE = 10

  def index
    @categories = Category.paginate(page: params[:page], per_page: PER_PAGE)
  end
end
