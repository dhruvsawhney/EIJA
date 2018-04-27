class AnalyticsModalController < ApplicationController
  def show
    l = Line.new
    @hash = l.countAnalytics(cookies[:play_id])
    @speakers = l.getAllSpeakers(cookies[:play_id])
    render :layout => false
  end
end
