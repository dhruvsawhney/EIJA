class Line < ApplicationRecord
  belongs_to :scene
  has_many :edits, through: :line_cuts
  has_many :words

  # a key helper method used in the front-end data rendering
  # output: gets all the lines for a play_id and scene_id pairing
  def lineByPlayScene(play_id,scene_id)

    arr = Act.find_by_sql ["select * from Acts where play_id = ?",play_id]

    arr.each do |act|
      puts "The act id is: #{act.id}"
    end

    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten

    scenes.each do |s|
      puts "The scene id is: #{s.id} and act id is: #{s.act_id}"
    end

    puts "The arg scene_id is: #{scene_id}"

    scenes.each do |scene|
      puts "Before check"
      puts "Scene.id class is :#{scene.id.class}"
      puts "Scene.id value is :#{scene.id}"
      puts "Scene_id class is :#{scene_id.class}"
      puts "Scene_id value is :#{scene_id}"
      if scene.id == scene_id
        puts "After check"
        return Line.find_by_sql ["select * from Lines where scene_id = ? order by number",scene.id]
      end
    end
  end

  # gets all the lines for the play in session
  # input: the play_id
  # output: the list of Lines for the given play id
  def getPlayLines(play_id)

    arr = Act.find_by_sql ["select * from Acts where play_id = ?",play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten
    return scenes.map {|scene| Line.find_by_sql ["select * from Lines where scene_id = ? order by number",scene.id]}.flatten

  end

  # Count the number of lines per character
  # output: A Hash, key is the speaker, value is the number of lines
  def countAnalytics(play_id)

    lines = getPlayLines(play_id)

    lines_per_character = Hash.new

    lines.each do |line|

      if line.currLength != nil && line.currLength > 0
        # the line is not cut
        if lines_per_character.has_key?(line.speaker)
          lines_per_character[line.speaker] += 1
        else
          lines_per_character[line.speaker] = 1
        end
      end
    end
    return lines_per_character
  end


  # note: the method below is meant for front-end data rendering

  # input: the play_id, scene_id
  # output: a list of all_pairs
  # all_pairs = list of 'a_pair'
  # a_pair = list of 'speaker','many_lines'
  # many_lines = list of 'a_line' -> [T|F , Lines]
  # a_line = list of 'wordID', 'text' -> [T|F, wordID, text]

  # def renderActScene(play_id,scene)
  #
  #   # list of [speaker, many lines]
  #   all_pairs = []
  #
  #   # lines = Line.find_by_sql ["Select * from Lines where scene_id = ? order by number", scene]
  #
  #   lines = lineByPlayScene(play_id,scene)
  #
  #   index = 0
  #
  #   lines.each do |l|
  #     # speaker, many lines
  #     a_pair = []
  #     many_lines = []
  #
  #
  #     # # add a boolean to indicate
  #     # # whether a line is cut
  #     if l.currLength != 0
  #       flag = false
  #     else
  #       flag = true
  #     end
  #
  #     spk = l.speaker
  #     # elements are [T|F, wordID, text]
  #     a_line = []
  #
  #
  #     words = Word.where(:line_id => l.id)
  #
  #     words.each do |wd|
  #       # the word is not in the Cuts table
  #       if Cut.where(:word_id => wd.id).length == 0
  #         a_line.append([false, wd.id, wd.text])
  #       else
  #         a_line.append([true, wd.id, wd.text])
  #       end
  #     end
  #
  #     # do not add empty lines to the nested-list structure
  #     if a_line.size == 0
  #       next
  #     end
  #
  #     if index != 0
  #       prev_pair = all_pairs[all_pairs.length - 1]
  #
  #       prev_speaker = prev_pair[0]
  #
  #       if prev_speaker == spk
  #         # add to "many_lines" for the previous speaker
  #         prev_pair[1].append([flag, a_line])
  #
  #       else
  #         many_lines.append([flag, a_line])
  #         # make "a_pair"
  #         a_pair.append(spk)
  #         a_pair.append(many_lines)
  #         # add to "all_pairs"
  #         all_pairs.append(a_pair)
  #       end
  #
  #     else
  #       # make from sratch
  #       many_lines.append([flag, a_line])
  #       a_pair.append(spk)
  #       a_pair.append(many_lines)
  #       all_pairs.append(a_pair)
  #     end
  #
  #     # increment index at end of each "line-iteration"
  #     index += 1
  #   end
  #   return all_pairs
  # end

  def renderActScene(play_id,scene,group_number)

    # list of [speaker, many lines]
    all_pairs = []

    # lines = Line.find_by_sql ["Select * from Lines where scene_id = ? order by number", scene]

    # get all the lines for a particular group
    lines = lineByPlayScene(play_id,scene)

    index = 0

    lines.each do |l|
      # speaker, many lines
      a_pair = []
      many_lines = []


      # # add a boolean to indicate
      # # whether a line is cut
      if l.currLength != 0
        flag = false
      else
        flag = true
      end

      spk = l.speaker
      # elements are [T|F, wordID, text]
      a_line = []


      words = Word.where(:line_id => l.id)

      words.each do |wd|
        # the word is not in the Cuts table
        # change made to check for GroupNumber in the Cuts table
        if Cut.where(:word_id => wd.id, :groupNum => group_number).length == 0
          a_line.append([false, wd.id, wd.text])
        else
          a_line.append([true, wd.id, wd.text])
        end
      end

      # do not add empty lines to the nested-list structure
      if a_line.size == 0
        next
      end

      if index != 0
        prev_pair = all_pairs[all_pairs.length - 1]

        prev_speaker = prev_pair[0]

        if prev_speaker == spk
          # add to "many_lines" for the previous speaker
          prev_pair[1].append([flag, a_line])

        else
          many_lines.append([flag, a_line])
          # make "a_pair"
          a_pair.append(spk)
          a_pair.append(many_lines)
          # add to "all_pairs"
          all_pairs.append(a_pair)
        end

      else
        # make from sratch
        many_lines.append([flag, a_line])
        a_pair.append(spk)
        a_pair.append(many_lines)
        all_pairs.append(a_pair)
      end

      # increment index at end of each "line-iteration"
      index += 1
    end
    return all_pairs
  end






  # a wrapper function to get all Act, Scene pairs in the play
  # output: HashMap, key: [act_id, scene_id] is a unique pairing, value: [many_lines]

  def renderAllActScenes(play_id)
    play = Hash.new
    scenes = Scene.all

    scenes.each do |scene|

      key = [scene.act_id, scene.id]

      val = renderActScene(play_id,scene.id)

      play[key] = val
    end

    return play
  end



  # the method below is used exclusively for CueScript dependencies

  # input: the play_id, scene_id
  # output: a list of all_pairs
  # all_pairs = list of 'a_pair'
  # a_pair = list of 'speaker','many_lines'
  # many_lines = list of 'a_line' -> [T|F , Lines]
  # a_line = list of 'wordID', 'text' -> [T|F, wordID, text]

  def getActScene(play_id,scene)

    # list of [speaker, many lines]
    all_pairs = []
    # order lines by the number, not by id, attribute to ensure correctness of lines rendered

    # lines = Line.find_by_sql ["Select * from Lines where scene_id = ? order by number", scene]

    lines = lineByPlayScene(play_id,scene)

    puts "#{lines}"
    puts "#{lines.class}"

    index = 0
    lines.each do |l|

      if l.number == nil
        next
      end

      # speaker, many lines
      a_pair = []
      many_lines = []

      # the line is not cut
      if l.currLength != 0
        spk = l.speaker

        # elements are [wordID, text]
        a_line = []

        words = Word.where(:line_id => l.id)

        if words == nil
          next
        end

        words.each do |wd|
          # the word is not in the Cuts table
          if Cut.where(:word_id => wd.id).length == 0
            a_line.append([wd.id, wd.text])
          end
        end

        # do not add empty-lines to the nested structure
        if a_line.size == 0
          next
        end

        if index != 0
          prev_pair = all_pairs[all_pairs.length - 1]

          prev_speaker = prev_pair[0]

          if prev_speaker == spk
            # to many_lines
            prev_pair[1].append(a_line)
          else

            many_lines.append(a_line)
            a_pair.append(spk)
            a_pair.append(many_lines)
            all_pairs.append(a_pair)
          end

        else
          # make from sratch
          many_lines.append(a_line)
          a_pair.append(spk)
          a_pair.append(many_lines)
          all_pairs.append(a_pair)
        end
      end
      index += 1
    end
    return all_pairs
  end



  # HARD_CODED, USED FOR DEBUGGING PURPOSES

  # a helper function to print the nested structure
  # Helpful to print the data in the views in such a manner
  def printLines
    # the arg for getActScene can be changed
    # to swap data printed to terminal
    blocks = getActScene(1,1)

    blocks.each do |block|
      # the speaker
      puts "#{block[0]}"

      # all the lines spoken by the speaker at that instance
      lines = block[1]

      lines.each do |line|
        words = []

        line.each do |wd|
          words.append(wd[1])
        end

        str = words.join(" ")
        puts "#{str}"
      end
    end
  end


  ## Two Helper functions to support cue-scripts ##

  #input: list of "many_lines"
  # output: [STAGE, list of lines spoken]

  def getStageScript(stage_lines)
    lines = []

    stage_lines.each do |sline|
      swords = []

      sline.each do |swd|
        # extra-cleaning on swd[1] as it contains \n in strings
        clean_str = swd[1].gsub(/\n/, "")
        swords.append(clean_str)
      end

      str = swords.join(" ")
      lines.append(str)
    end

    return ["STAGE", lines]

  end

  # input: the name of the speaker, list of "many_lines"
  # output: [speaker, [list of lines spoken]]
  def getSpeakerScript(speakerName, speaker_lines)
    lines = []

    speaker_lines.each do |line|
      # for each line
      # process the list-of-lists to make sentence
      words = []
      # a line is a list of lists of wdId, text
      line.each do |wd|
        words.append(wd[1])
      end

      str = words.join(" ")
      lines.append(str)
    end

    return [speakerName, lines]

  end


  # Main function to generate a cue script

  # input: SCENE ID, Speaker (for whom to build the cue-script for)
  # output: [speaker,[lines]]

  def getCueScript(play_id,sceneID, speaker)
    result = []

    hasSpeaker = false

    blocks = getActScene(play_id,sceneID)

    (0...blocks.length).each do |i|
      # a block is a [speaker, [list of many lines]]
      # prev_block = blocks[i - 1]
      curr_block = blocks[i]

      # to get the stage cues
      if curr_block[0] == "STAGE"
        stage_lines = curr_block[1]
        i1 = getStageScript(stage_lines)
        result.append(i1)

      elsif curr_block[0] == speaker
        hasSpeaker = true
        #### the previous-speaker ####
        val = (i - 1)
        if val >= 0 and blocks[val][0] != "STAGE"
          # client would like the last word,
          # instead of the last line

          prev_block = blocks[val]
          prev_block_lines = prev_block[1]
          last_line = prev_block_lines[prev_block_lines.length - 1]

          last_line_wds = []

          # the last line removed as per Client request
          # last_line.each do |lol|
          #   last_line_wds.append(lol[1])x
          # end
          # prev_sentence = last_line_wds.join(" ")

          # the last word
          last_line_wds = last_line[last_line.length - 1][1]
          last_line_wds = ".." * 5 + last_line_wds

          i2 = [prev_block[0], [last_line_wds]]
          result.append(i2)
        end
        #### the speaker ####
        lines = curr_block[1]
        i3 = getSpeakerScript(curr_block[0], lines)
        result.append(i3)
      end
    end

    if hasSpeaker
      return result
    else
      return []
    end
  end

  # HARD-CODED FOR DEBUGGING

  # a wrapper function to generate Cue-scripts
  # Current status: print for a given sceneID and Speaker
  # Aim: to generate cue-script across all SceneIDs

  def selectCueScript(speaker)
    # the scene ID
    # the speaker

    lol = getCueScript(1,1, speaker)

    # lol = getCueScript(2, "\nFIRST\n \nMERCHANT\n")

    return lol

  end

  # input : LOL where the first item is  the speaker and the second item is a list of sentences
  # output: print to terminal/views to display data
  def printCueScipt
    lol = selectCueScript("\nFIRST\n \nMERCHANT\n")
    puts "Printing starts ...."

    lol.each do |elem|
      puts "#{elem[0]}"

      lines = elem[1]

      lines.each do |line|
        puts "#{line}"
      end
    end
  end


  # output: create a list of all speakers in the Play
  def getAllSpeakers(play_id)
    speakerHash = {}

    arr = Act.find_by_sql ["select * from Acts where play_id = ?",play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten
    arr = scenes.map {|scene| Line.find_by_sql ["select distinct(speaker) from Lines where scene_id = ? order by number",scene.id]}.flatten
    # get all unique entries
    arr = arr.uniq{|line| line.speaker}

    # arr = Line.find_by_sql("select distinct(speaker) from Lines")

    arr.each do |i|
      val = i.speaker.gsub(/\n/, "")
      speakerHash[val] = i.speaker
    end

    speakerHash = Hash[speakerHash.sort]
    return speakerHash
  end

  # output: a list of all sceneIDs
  def getAllScenes(play_id)
    sceneIDs = []

    arr = Act.find_by_sql ["select * from Acts where play_id = ?",play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten

    scenes.each do |scene|
      sceneIDs.append(scene.id)
    end

    return sceneIDs
  end



  ################ Main function for Cue-script generation ##############

  # input: speaker: speaker Name
  # output: Hash, Key: [actId,sceneId], value: LOL [speaker,[lines]]
  #
  # need to pass play_id to it
  def getAllCueScript(play_id, speaker)

    sceneIDs = getAllScenes(play_id)


    hash = getAllSpeakers(play_id)

    dbSpeaker = hash[speaker]

    result = {}

    sceneIDs.each do |sceneID|
      val = getCueScript(play_id, sceneID, dbSpeaker)
      result[sceneID] = val
    end

    result = Hash[result.sort]

    # hard-coded for the current play
    acts = Act.where(play_id: 1)

    for i in 0 ... acts.size
      aID = acts[i].id

      scenes = Scene.where(act_id: aID)

      # use j as proxy for sceneID
      for j in 0...scenes.size
        sID = scenes[j].id
        # puts "THE ACT IS: #{aID} THE SCENE IS: #{sID}"

        key = [aID,j+1]
        result[key] = result[sID]
        result.delete(sID)
      end
    end

    return result
  end


  # # Helper functions for the Matching feature
  #
  # # the array of speakers keys
  # def transformSpeaker
  #   arr = getAllSpeakers.keys
  #
  #   for i in 0...arr.length do
  #     arr[i] = arr[i].split
  #   end
  #   return arr
  # end
  #
  # # arr: cleaned text
  # # index: of arr
  # # tSpeaker: the list of speakers made into a list
  # # result: the matches for speakers
  # # speakers: a list of speakers in the play
  # def recurseMatches(arr, index, tSpeaker, result, speakers)
  #   if index >= arr.length
  #     return result
  #
  #   else
  #     word = arr[index]
  #     word = word.upcase
  #     for i in 0...tSpeaker.length
  #       subArr = tSpeaker[i]
  #
  #       if subArr.length != 0
  #         if subArr[0] == word
  #           subArr.delete_at(0)
  #           if tSpeaker[i].length == 0
  #             # puts "#{speakers[i]}"
  #             # puts "#{speakers[i].class}"
  #             result.insert(result.length - 1, speakers[i])
  #             val = speakers[i]
  #
  #           end
  #         end
  #       end
  #
  #     end
  #     return recurseMatches(arr, index + 1, tSpeaker, result, speakers)
  #   end
  # end

  # BROKEN FEATURE :: DO NOT CALL

  # def countCharMatches
  #   speakers = Line.find_by_sql("select distinct(speaker) from Lines order by speaker")
  #
  #   puts "#{speakers}"
  #   map = Hash.new
  #
  #   # map the speaker to index in the matrix
  #
  #   speakers.each_with_index do |s, index|
  #     val = s.speaker
  #     map[index] = val
  #   end
  #
  #
  #   acts = Act.find_by_sql("select * from Acts")
  #   # names of the speakers corresponding to i
  #   set = Set.new
  #   # initialize the matrix to 0s
  #   arr = Array.new(speakers.length) {Array.new(speakers.length)}
  #
  #   for i in 0...speakers.length do
  #     for j in 0...speakers.length do
  #       arr[i][j] = 0
  #     end
  #   end
  #
  #
  #   for i in 0...speakers.length do
  #     for j in i + 1...speakers.length do
  #
  #       if !set.include?(map[j])
  #
  #         acts.each do |act|
  #           scenes = Scene.find_by_sql ["select * from Scenes where act_id = ?", act.id]
  #           # puts "#{scenes}"
  #
  #           spk1 = map[i]
  #           spk2 = map[j]
  #           # spk, in scene flag, num-lines
  #           result = Array.new(2) {Array.new(3)}
  #           result[0][0] = spk1
  #           result[0][1] = false
  #           result[0][2] = 0
  #           result[1][0] = spk2
  #           result[1][1] = false
  #           result[1][2] = 0
  #
  #           scenes.each do |scene|
  #             script = renderActScene(scene.id)
  #
  #
  #             script.each do |block|
  #               if block[0] == spk1 || block[0] == spk2
  #                 index = block[0] == spk1 ? 0 : 1
  #                 result[index][1] = true
  #                 result[index][2] += block[1].length
  #               end
  #             end
  #           end
  #           if result[0][1] && result[1][1]
  #             arr[i][j] = result[0][2] + result[1][2]
  #           end
  #
  #
  #           # puts "#{scenes}"
  #
  #         end
  #       end
  #
  #     end
  #     set = set.add(map[i])
  #   end
  #
  #   return arr
  #
  # end

  # output: a two-element array where the first element is a HashMap, second element is Set
  # HashMap, key: sceneID, val: the list of unique characters that speak in the play
  # Set: of the characters in the play (as determined by the algorithm)

  # def matching
  #
  #   map = Hash.new
  #   set = Set.new
  #
  #   scenes = getAllScenes
  #
  #   scenes.each do |scene|
  #     stageLines = Line.find_by_sql ["Select * from Lines where scene_id = ? and speaker = 'STAGE' ", scene]
  #
  #     stageLines.each do |line|
  #       words = Word.find_by_sql ["select * from Words where line_id = ?", line.id]
  #       # puts "#{words}"
  #       words.each do |wd|
  #         # processing the text
  #         text = wd.text
  #         # add this spacing
  #         text = text.gsub("\n", " ")
  #         text = text.gsub(".", "")
  #         text = text.gsub(",", "")
  #         # the array of words
  #         arr = text.split
  #         cue = "Enter"
  #
  #         if arr[0] == cue
  #           speakers = getAllSpeakers.keys
  #           tSpeaker = transformSpeaker
  #           result = []
  #           result = recurseMatches(arr, 1, tSpeaker, result, speakers)
  #           # puts "#{result} + #{arr}"
  #           # code to add elements to the set in both places
  #           if map.has_key?(scene)
  #             val = map[scene]
  #
  #             result.each do |spk|
  #               set.add(spk)
  #               if !val.include?(spk)
  #                 val = val.insert(val.length - 1, spk)
  #               end
  #             end
  #             result[scene] = val
  #           else
  #             # add to set
  #             result.each do |spk|
  #               set.add(spk)
  #             end
  #             map[scene] = result
  #           end
  #         end
  #       end
  #     end
  #     puts ".............................................................."
  #   end
  #   # sort the order of the set
  #   # the set should return all the characters expect for "STAGE"
  #   set = SortedSet.new(set)
  #   return [map, set]
  # end
  #
  # # output: a 2D matrix where i,j represent two characters
  # # arr[i][j] denotes the number of times the two characters appear
  # # as a pair across the play
  # def charMatrix
  #   mapSet = matching
  #
  #   map = mapSet[0]
  #   set = mapSet[1]
  #
  #   charToNum = Hash.new
  #   index = 0
  #   # map a character to an index
  #   set.each do |s|
  #     charToNum[s] = index
  #     index += 1
  #   end
  #
  #   # initialize the array
  #   arr = Array.new(set.length) {Array.new(set.length)}
  #   for i in 0...arr.length do
  #     for j in 0...arr.length do
  #       arr[i][j] = 0
  #     end
  #   end
  #
  #   # create the matrix
  #
  #   # for all the scenes
  #   map.each do |key, val|
  #     if val.length != 0
  #       # for a given scene
  #       for i in 0...val.length do
  #         for j in i + 1...val.length do
  #           # get the names of the chars
  #           r = val[i]
  #           c = val[j]
  #
  #           # charName to index mapping
  #           arr[charToNum[r]][charToNum[c]] += 1
  #         end
  #       end
  #     end
  #   end
  #   return arr
  # end
  #
  # # returns an array where the first element is the list of characters
  # #                        the second element is the 2D matrix
  # def charFeatureWrapper
  #   resultArr = []
  #
  #   # index 1 of matching arr is the sorted list of speakers
  #   sortedSet = matching[1]
  #   # convert the sorted set into an array to index easily
  #   # for front-end rendering
  #   arr = []
  #
  #   sortedSet.each do |elem|
  #     arr << elem
  #   end
  #
  #   resultArr[0] = arr
  #   # the r,c characters are indices of the sorted list of speakers
  #   resultArr[1] = charMatrix
  #   return resultArr
  # end

end

