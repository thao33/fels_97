class AdminController < ApplicationController
  layout "admin"
  before_action :is_admin?

  private
  def is_admin?
    unless logged_in? and current_user.is_admin?
      redirect_to login_path
    end
  end
end
