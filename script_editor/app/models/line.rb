class Line < ApplicationRecord
  belongs_to :scene
  has_many :edits, through: :line_cuts
  has_many :words


  # Count the number of lines per character
  # output: A Hash, key is the speaker, value is the number of lines
  def countAnalytics
    lines_per_character = Hash.new

    lines = Line.all

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

  # input: the scene_id
  # output: a list of all_pairs
    # all_pairs = list of 'a_pair'
    # a_pair = list of 'speaker','many_lines'
    # many_lines = list of 'a_line' -> [T|F , Lines]
    # a_line = list of 'wordID', 'text' -> [T|F, wordID, text]

  def renderActScene(scene)

    # list of [speaker, many lines]
    all_pairs = []

    lines = Line.find_by_sql ["Select * from Lines where scene_id = ? order by number", scene]
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
        if Cut.where(:word_id => wd.id).length == 0
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

  # input: the scene_id
  # output: a list of all_pairs
    # all_pairs = list of 'a_pair'
    # a_pair = list of 'speaker','many_lines'
    # many_lines = list of 'a_line' -> [T|F , Lines]
    # a_line = list of 'wordID', 'text' -> [T|F, wordID, text]

  def getActScene(scene)

    # list of [speaker, many lines]
    all_pairs = []
    # order lines by the number, not by id, attribute to ensure correctness of lines rendered
    lines = Line.find_by_sql ["Select * from Lines where scene_id = ? order by number", scene]

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


  # a wrapper function to get all Act, Scene pairs in the play
  # output: HashMap, key: [act_id, scene_id] is a unique pairing, value: [many_lines]

  def renderAllActScenes()
    play = Hash.new
    scenes = Scene.all

    scenes.each do |scene|

      key = [scene.act_id, scene.id]

      val = renderActScene(scene.id)

      play[key] = val
    end

    return play
  end


  # a helper function to print the nested structure
  # Helpful to print the data in the views in such a manner
  def printLines
    # the arg for getActScene can be changed
    # to swap data printed to terminal
    blocks = getActScene(1)

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

  def getCueScript(sceneID, speaker)
    result = []

    blocks = getActScene(sceneID)

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
        #### the previous-speaker ####
        val = (i - 1)
        if val >= 0 and blocks[val][0] != "STAGE"

          prev_block = blocks[val]
          prev_block_lines = prev_block[1]
          last_line = prev_block_lines[prev_block_lines.length - 1]

          last_line_wds = []
          last_line.each do |lol|
            last_line_wds.append(lol[1])
          end

          prev_sentence = last_line_wds.join(" ")
          i2 = [prev_block[0], [prev_sentence]]
          result.append(i2)
        end
        #### the speaker ####
        lines = curr_block[1]
        i3 = getSpeakerScript(curr_block[0], lines)
        result.append(i3)
      end
    end

    return result
  end

  # a wrapper function to generate Cue-scripts
  # Current status: print for a given sceneID and Speaker
  # Aim: to generate cue-script across all SceneIDs

  def selectCueScript
    # the scene ID
    # the speaker

    # lol = getCueScript(1, "\nEGEON\n")

    lol = getCueScript(2, "\nFIRST\n \nMERCHANT\n")

    return lol

  end

  # input : LOL where the first item is  the speaker and the second item is a list of sentences
  # output: print to terminal/views to display data
  def printCueScipt
    lol = selectCueScript
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
  def getAllSpeakers
    speakerLst = []

    arr = Line.find_by_sql("select distinct(speaker) from Lines")

    arr.each do |i|
      speakerLst.append(i.speaker)
    end

    return speakerLst

  end

  # output: a list of all sceneIDs
  def getAllScenes
    sceneIDs = []

    scenes = Scene.all

    scenes.each do |scene|
      sceneIDs.append(scene.id)
    end

    return sceneIDs
  end
  
end

