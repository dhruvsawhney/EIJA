class Scene < ApplicationRecord
  belongs_to :act
  has_many :lines

  # output: a LOL where first element is the act id and the 2nd element is the list of scenes

  def getAllActScenes(play_id)
    arr = Act.find_by_sql ["select * from Acts where play_id = ?",play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten

    # edge-case
    if scenes.size == 0
      return []
    end
    out = Hash.new()
    result = []

    # add the first scene
    fst_scene = scenes[0]
    result.append([fst_scene.act_id,[fst_scene.id]])

    (0...scenes.length).each do |i|
      curr_scene = scenes[i]
      current_act_num = Act.where({id: curr_scene.act_id})[0].number
      sub = Hash.new()
      sub[curr_scene.number] = curr_scene.id
      if out.key?(current_act_num)#if the act key is in hash
        out[current_act_num] = out[current_act_num].append(sub)
      else  #if the key is not on the hash
        out[current_act_num] = [sub]
      end

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

    return out
  end

  # output: Masks the true the actId - Scene numbering(above)
  # for front-end rendering

  def reformatActScene(play_id)

    actScene = getAllActScenes(play_id)

    out = Hash.new()
    (0...actScene.length).each do |i|
      out[actScene[i][0]] = actScene[i][1]
      lol = actScene[i]
      sceneLen = lol[1].size
      (0...sceneLen).each do |j|
        lol[1][j] = j+1
      end
    end
    puts "OUT: #{out}"
    return out
  end

end
