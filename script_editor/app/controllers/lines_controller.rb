class LinesController < ApplicationController
  before_action :set_line, only: [:show, :edit, :update, :destroy]


  def show
    l = Line.new
    @hash = l.getAllSpeakers
  end

  # required stub for the lines/show route to work
  def set_line
  end

  # generate the cue-script
  # regex matching to santize user-input is important
  def script

    l = Line.new
    @queScript = l.getAllCueScript(cookies[:play_id], params[:charecterName])

  end

  # GET /lines/new
  def new
    @line = Line.new
  end

end
