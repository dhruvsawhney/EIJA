class SceneRenderController < ApplicationController

  def show

    l = Line.new
    @scene = l.renderActScene(1,params[:id])
    # @scene.each do |p|
    #   puts "#{p}"
    # end
    render :layout => false
  end
end
