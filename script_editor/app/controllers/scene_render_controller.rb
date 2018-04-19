class SceneRenderController < ApplicationController

  def show
    sceneQuery = Scene.where({id:Integer(params[:id])})[0]
    @scene_id = params[:id]
    @scene_number = sceneQuery.number
    @act_number = Act.where({id: sceneQuery.act_id})[0].number
    @scene = Line.new.renderActScene(Integer(cookies[:play_id]),Integer(params[:id]))
    # @scene.each do |p|
    #   puts "#{p}"
    # end
    render :layout => false
  end
end
