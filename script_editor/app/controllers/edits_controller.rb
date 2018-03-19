require 'nokogiri'

class EditsController < ApplicationController
  def show
    @edit = Edit.find(params[:id])
    @play = @edit.play
    @acts = Act.joins(:play).where(:play_id => @play.id).order(:number)
    @relCuts = Cut.where(:edit_id => @edit.id).pluck(:word_id).to_a.to_set

    l = Line.new
    @hash = l.countAnalytics
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
end
