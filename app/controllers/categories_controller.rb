class CategoriesController < ApplicationController
  def index
    @categories = Category.paginate page: params[:page]
  end

  def create
    category = Category.new category_params
    if category.save
      flash[:success] = I18n.t "notifications.categories.create_succeed"
      NewCategoryNotifyService.new(category).notify
      redirect_to category
    else
      flash[:notice] = I18n.t "errors.categories.create_failed"
      render :new
    end
  end

  def show
  end

  private
  def category_params
    params.require(:category).permit :name, :description
  end
end
