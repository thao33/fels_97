class RelationshipsController < ApplicationController

  def index
    @user = User.find params[:user_id]
    type = params[:type]
    @title = I18n.t "profile.title.#{type}"
    @follow_rels = @user.send type
    render "users/show"
  end

  def create
    @user = User.find params[:followed_id]
    current_user.follow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end
end
