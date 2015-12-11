class UsersController < ApplicationController

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = I18n.t "user_destroy.value"
    redirect_to users_url
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = I18n.t "user_create.value"
      redirect_to @user
    else
      render "new"
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes! name: params[:user][:name]
      flash[:success] = I18n.t "profile.updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = I18n.t "user_unlogin.warning"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url  unless current_user? @user
  end
end
