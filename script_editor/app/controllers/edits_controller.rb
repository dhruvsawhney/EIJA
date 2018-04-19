require 'nokogiri'
require 'open-uri'
class EditsController < ApplicationController
  before_action :authenticate_user!

  # before_filter :set_current_play_id
  #
  # def set_current_play_id
  #   #  set @current_account from session data here
  #   Line.curr_play_id = params[:id]
  # end


  def show

    # ENSURE THIS IS THE PLAY ID
    cookies[:play_id] = params[:id]

    # puts "The current user is: #{current_user.id} and the current group is #{current_user.groups_id}"

    # get the group number associated with this row in the Groups DB
    x = Group.find_by_sql [ "select * from Groups where id = ?",current_user.groups_id]
    groupNum = x[0].groupNum

    # cookies[:group_number] = 2
    #
    puts "THE THING IS :: #{cookies[:group_number]}"

    puts "THE CLASS THING IS :: #{cookies[:group_number].class}"

    cookies[:group_number] = groupNum

    puts "The current user is: #{current_user.id} and the REAL GROUP NUMBER is #{groupNum}"


    @edit = Edit.where({user_id: current_user.id , play_id:cookies[:play_id], groups_id: current_user.groups_id})

    if @edit.length == 0
      @edit = EditsController.makeEdit(current_user.id, cookies[:play_id], current_user.groups_id)
      @edit = Edit.where({user_id: current_user.id , play_id:cookies[:play_id], groups_id: current_user.groups_id})
    end

    # get the first element from the array
    @edit = @edit[0]

    l = Line.new
    @hash = l.countAnalytics(cookies[:play_id])

    # WHY IS THIS HARD-CODED
    @scene = l.renderActScene(cookies[:play_id],1)

 end

  def compress
    @edit = Edit.find(params[:id])
    @play = @edit.play
    @acts = Act.joins(:play).where(:play_id => @play.id).order(:number)
    @relCuts = Cut.where(:edit_id => @edit.id).pluck(:word_id).to_a.to_set
  end

  def new
    @play = Play.find(params[:id])

    @name = session[:user_id]
    puts 'hello'
    @user = current_user
    if Edit.where(:user_id => @user.id, :play_id => @play.id) != nil
      @edit = Edit.where(:user_id => @user.id, :play_id => @play.id).where('updated_at != created_at').order(created_at :desc)
    else
      @edit = Edit.create({:user_id => @user.id, :play_id => @play.id})
    end
    #@link = "/edits/" + (@edit.id.to_s)
    # needs to be UserId
    @link = "/edits/" + (@edit.id.to_s)
    redirect_to @link
  end

  # make an entry in the Edits table by passing the parameters
  def self.makeEdit(user_id, play_id, group_id)
    @play = Play.find(play_id)
    @edit = Edit.create({:user_id => user_id, :play_id => play_id, :groups_id => group_id})
    return @edit
  end


  # def group_edit
  #   @edit = Edit.find(params[:id])
  #   puts "#{@edit}"
  #   @play = @edit.play
  #   group_id = @edit.groups_id
  #   group_name = Group.find_by_sql(["Select name from Groups where group_id = ?",group_id])
  #   @link = "/edits/group_edit/"+ (@edit.id.to_s) + "/" + (@group_name.to_s)

  # end
end
