class SceneRenderController < ApplicationController
  def show
    l = Line.new
    @hash = l.countAnalytics
    @scene1 = l.getActScene(1)
  end
end
