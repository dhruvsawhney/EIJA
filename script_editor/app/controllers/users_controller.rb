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
    end

    # the active users
    user_obj = User.new
    @active_users = user_obj.getAllUsers
    @group_users = user_obj.getUsersFromGroups
    @playGroupData = user_obj.getplaysFromGroups
  end

  def new
    @user = User.new
  end

  def createGroup
    group_obj = Group.new
    group_obj.createGroup(params[:data], params[:name])
  end


end
