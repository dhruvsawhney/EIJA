class Scene < ApplicationRecord
  belongs_to :act
  has_many :lines

  # output: a LOL where first element is the act id and the 2nd element is the list of scenes

  def getAllActScenes
    scenes = Scene.find_by_sql("Select * from Scenes order by act_id")

    # edge-case
    if scenes.size == 0
      return []
    end

    result = []

    # add the first scene
    fst_scene = scenes[0]
    result.append([fst_scene.act_id,[fst_scene.id]])

    (1...scenes.length).each do |i|
      curr_scene = scenes[i]
      # act-id is different
      if curr_scene.act_id != result[result.size-1][0]
        lst = []
        scene_lst = [curr_scene.id]
        lst = [curr_scene.act_id, scene_lst]
        result.append(lst)
      else
        result[result.size-1][1].append(curr_scene.id)
      end
    end

    return result
  end

  # output: Masks the true the actId - Scene numbering(above)
  # for front-end rendering

  def reformatActScene
    actScene = getAllActScenes

    (0...actScene.length).each do |i|
      lol = actScene[i]
      sceneLen = lol[1].size
      (0...sceneLen).each do |j|
        lol[1][j] = j+1
      end
    end
    return actScene
  end

end
