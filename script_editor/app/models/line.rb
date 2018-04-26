# a critical file to render the  play data on the front-end
class Line < ApplicationRecord
  belongs_to :scene
  has_many :edits, through: :line_cuts
  has_many :words

  # a key helper method used in the front-end data rendering
  # output: gets all the lines for a play_id and scene_id pairing
  def lineByPlayScene(play_id, scene_id)

    arr = Act.find_by_sql ["select * from Acts where play_id = ?", play_id]

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
        return Line.find_by_sql ["select * from Lines where scene_id = ? order by number", scene.id]
      end
    end
  end

  # gets all the lines for the play in session
  # input: the play_id
  # output: the list of Lines for the given play id
  def getPlayLines(play_id)

    arr = Act.find_by_sql ["select * from Acts where play_id = ?", play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten
    return scenes.map {|scene| Line.find_by_sql ["select * from Lines where scene_id = ? order by number", scene.id]}.flatten

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

  def renderActScene(play_id, scene, group_number)

    # list of [speaker, many lines]
    all_pairs = []

    # get all the lines for a particular group
    lines = lineByPlayScene(play_id, scene)

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


  # the method below is used exclusively for CueScript dependencies

  # input: the play_id, scene_id
  # output: a list of all_pairs
  # all_pairs = list of 'a_pair'
  # a_pair = list of 'speaker','many_lines'
  # many_lines = list of 'a_line' -> [T|F , Lines]
  # a_line = list of 'wordID', 'text' -> [T|F, wordID, text]

  def getActScene(play_id, scene)

    # list of [speaker, many lines]
    all_pairs = []
    # order lines by the number, not by id, attribute to ensure correctness of lines rendered

    lines = lineByPlayScene(play_id, scene)

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


  # DEBUGGING METHODS

  # a helper function to print the nested structure
  # Helpful to print the data in the views in such a manner
  def printLines
    # the arg for getActScene can be changed
    # to swap data printed to terminal
    blocks = getActScene(1, 1)

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

  def getCueScript(play_id, sceneID, speaker)
    result = []

    hasSpeaker = false

    blocks = getActScene(play_id, sceneID)

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

    lol = getCueScript(1, 1, speaker)
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

    arr = Act.find_by_sql ["select * from Acts where play_id = ?", play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten
    arr = scenes.map {|scene| Line.find_by_sql ["select distinct(speaker) from Lines where scene_id = ? order by number", scene.id]}.flatten
    # get all unique entries
    arr = arr.uniq {|line| line.speaker}

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

    arr = Act.find_by_sql ["select * from Acts where play_id = ?", play_id]
    scenes = arr.map {|act| Scene.find_by_sql [" select * from Scenes where act_id = ?", act.id]}.flatten

    scenes.each do |scene|
      sceneIDs.append(scene.id)
    end

    return sceneIDs
  end


  # DEBUGGING FOR CUE-SCRIPT

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

    for i in 0...acts.size
      aID = acts[i].id

      scenes = Scene.where(act_id: aID)

      # use j as proxy for sceneID
      for j in 0...scenes.size
        sID = scenes[j].id
        # puts "THE ACT IS: #{aID} THE SCENE IS: #{sID}"

        key = [aID, j + 1]
        result[key] = result[sID]
        result.delete(sID)
      end
    end

    return result
  end

end

