class Scene < ApplicationRecord
  belongs_to :act
  has_many :lines

  # output: a LOL where first element is the act id and the 2nd element is the list of scenes

  def getAllActScenes(play_id)
    arr = Act.find_by_sql ["select * from Acts where play_id = ?",play_id]

    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten
    puts"scenes: #{scenes}"
    puts"arr: #{arr}"
    # edge-case
    if scenes.size == 0
      return []
    end
    out = Hash.new()
    result = []
    puts"push: #{scenes}"

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
      else#if the key is not on the hash
        out[current_act_num] = [sub]
      end
      # puts"number: #{curr_scene.number}"
      # puts"Scene_id: #{curr_scene.id}"
      # puts"Act_Id: #{curr_scene.act_id}"
      # puts "Act Num: #{Act.where({id: curr_scene.act_id})[0].number}"
      # puts " empty #{out}"

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

  # def getFirstScenePlay(play_id)
  #   acts = Act.find_by_sql ["select * from Acts where play_id = ? order by id", play_id]
  #
  #   first_act_id = acts.first.id
  #   scene_id_lst = Scene.find_by_sql ["select id from Scenes where act_id = ? order by id", first_act_id]
  #
  #   first_scene_id = scene_id_lst[0].id
  #   return first_scene_id
  # end
  #

end
