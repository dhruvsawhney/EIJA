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
    a = Scene.new


    # sanitize input from the cookies

    # ENSURE THIS IS THE PLAY ID
    # why do we do this? -Alasdair
    cookies[:play_id] = params[:id]#gang gang
    # add to the cookie as the current Group Number
    if cookies[:group_num].nil?
      cookies[:group_num] = -1
    end
    puts "THE THING IS :: #{cookies[:group_num]}"

    puts "THE CLASS THING IS :: #{cookies[:group_num].class}"

    # puts "The current user is: #{current_user.id} and the REAL GROUP NUMBER is #{groupNum}"


    @edit = Edit.where({user_id: current_user.id , play_id:cookies[:play_id], groups_id: cookies[:group_num]})


    group_number = cookies[:group_num].to_i
    # group_number, user_id => group_id from the Groups table that corresponds to the current user
    g = Group.find_by_sql ["select * from Groups where user_id = ? and groupNum = ?",current_user.id, group_number]
    # returns an array and the object is at the first index
    g = g[0]


    # puts "THE THING IS :: #{cookies[:group_number]}"
    # puts "THE CLASS THING IS :: #{cookies[:group_number].class}"
    # puts "The current user is: #{current_user.id} and the REAL GROUP NUMBER is #{groupNum}"
    #be sure to change this so group id is the cookie so we can more easily change it
    # @edit = Edit.where({user_id: current_user.id , play_id:cookies[:play_id], groups_id: current_user.groups_id})
    @edit = Edit.where({user_id: current_user.id , play_id:cookies[:play_id], groups_id: g.id})

    if @edit.length == 0
      @edit = EditsController.makeEdit(current_user.id, cookies[:play_id], g.id)
      @edit = Edit.where({user_id: current_user.id , play_id:cookies[:play_id], groups_id: g.id})

    end

    # get the first element from the array
    # this edit Object is used at the front-end
    @edit = @edit[0]

    l = Line.new
    @hash = l.countAnalytics(cookies[:play_id])

    a = Scene.new
    @scene = l.renderActScene(cookies[:play_id],1, cookies[:group_number])
    @scene_id_map = a.getAllActScenes(cookies[:play_id])
    # puts "Out: #{a.getAllActScenes(cookies[:play_id])}"
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
    puts "Make the object"
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
