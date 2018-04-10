class AnalyticsModalController < ApplicationController
  def show
    l = Line.new
    @hash = l.countAnalytics
    @speakers = l.getAllSpeakers.keys
    @speakersPretty = @speakers.collect { |x| x.capitalize }
    render :layout => false
  end
end