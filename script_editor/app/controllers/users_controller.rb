class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new]
  def show
    @user = User.find(params[:id])
  end

  def admin
    #only allow access if user is admin
  	unless current_user.try(:admin?)
  		redirect_to root_path
  		flash.alert = "You must be logged in as admin"
      groups = current_user.getGroups
      # @edits = Edit.find_by_sql(["Select * from Edits where groups_id = ?", group_id])
    end

      # the active users
      user_obj = User.new
      @active_users = user_obj.getAllUsers

  end
    
  def new
    @user = User.new
  end

end
