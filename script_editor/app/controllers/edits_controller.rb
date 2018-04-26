require 'nokogiri'
require 'open-uri'
class EditsController < ApplicationController
  before_action :authenticate_user!


  # this function is called the first time a play is rendered
  def show
    a = Scene.new

    # sanitize input from the cookies
    cookies[:play_id] = params[:id]
    # add to the cookie as the current Group Number
    if cookies[:group_num].nil?
      cookies[:group_num] = -1
    end

    group_number = cookies[:group_num].to_i

    @edit = Edit.where({user_id: current_user.id, play_id: cookies[:play_id], groups_id: group_number})


    play_id = cookies[:play_id].to_i

    group_number = cookies[:group_num].to_i
    # group_number, user_id => group_id from the Groups table that corresponds to the current user
    g = Group.find_by_sql ["select * from Groups where user_id = ? and groupNum = ?", current_user.id, group_number]
    # returns an array and the object is at the first index
    g = g[0]

    @edit = Edit.where({user_id: current_user.id, play_id: play_id, groups_id: g.id})

    if @edit.length == 0
      @edit = EditsController.makeEdit(current_user.id, play_id, g.id)
      @edit = Edit.where({user_id: current_user.id, play_id: play_id, groups_id: g.id})

    end

    # get the first element from the array
    # this edit Object is used at the front-end
    @edit = @edit[0]

    l = Line.new
    @hash = l.countAnalytics(play_id)

    a = Scene.new

    first_scene_id = getFirstScenePlay(play_id)

    @scene = l.renderActScene(play_id, first_scene_id, group_number)
    @scene_id_map = a.getAllActScenes(play_id)
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

    @user = current_user
    if Edit.where(:user_id => @user.id, :play_id => @play.id) != nil
      @edit = Edit.where(:user_id => @user.id, :play_id => @play.id).where('updated_at != created_at').order(created_at :desc)
    else
      @edit = Edit.create({:user_id => @user.id, :play_id => @play.id})
    end
    @link = "/edits/" + (@edit.id.to_s)
    redirect_to @link
  end


  # a static function that interacts with the Edits table
  def self.makeEdit(user_id, play_id, group_id)
    @play = Play.find(play_id)
    @edit = Edit.create({:user_id => user_id, :play_id => play_id, :groups_id => group_id})
    return @edit
  end

  # return the first scene for the play
  # input: the play_id (of integer class)
  def getFirstScenePlay(play_id)
    acts = Act.find_by_sql ["select * from Acts where play_id = ? order by id", play_id]

    first_act_id = acts.first.id

    scene_id_lst = Scene.find_by_sql ["select id from Scenes where act_id = ? order by id", first_act_id]

    first_scene_id = scene_id_lst[0].id
    return first_scene_id
  end

end
