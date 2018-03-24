require 'nokogiri'

class EditsController < ApplicationController
  before_action :redirect_unless_admin


  def show
    @edit = Edit.find(params[:id])
    @play = @edit.play
    @acts = Act.joins(:play).where(:play_id => @play.id).order(:number)
    @relCuts = Cut.where(:edit_id => @edit.id).pluck(:word_id).to_a.to_set

    l = Line.new
    @hash = l.countAnalytics
    @scene1 = l.getActScene(1)
    # puts "#{@hash}"
    # puts "#{@hash.length}"
    # Line.countAnalytics
  end
  def compress
    @edit = Edit.find(params[:id])
    @play = @edit.play
    @acts = Act.joins(:play).where(:play_id => @play.id).order(:number)
    @relCuts = Cut.where(:edit_id => @edit.id).pluck(:word_id).to_a.to_set
  end
  def new
    @play = Play.find(params[:id])
    @user = current_user
    @edit = Edit.create({:user_id => @user.id, :play_id => @play.id})
    # @link = "/edits/" + (@edit.id.to_s)
    # needs to be UserId
    @link = "/edits/" + (@user.id.to_s)
    redirect_to @link
  end

  private
  #dont let normal user edit
  def redirect_unless_admin
    unless current_user.try(:admin?)
      flash[:error] = "Only admins can do that"
      @link = "/plays/" + (current_user.id.to_s)
    end
  end

end
