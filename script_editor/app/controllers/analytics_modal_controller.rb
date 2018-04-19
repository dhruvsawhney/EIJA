class AnalyticsModalController < ApplicationController
  def show
    l = Line.new
    @hash = l.countAnalytics(cookies[:play_id])
    @speakers = l.getAllSpeakers(cookies[:play_id]).keys

    # COMMENT OUT FOR NOW
    # @matrixData = l.charFeatureWrapper

    @speakersPretty = @speakers.collect { |x| x.capitalize }
    render :layout => false
  end
end
