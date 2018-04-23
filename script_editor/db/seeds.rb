# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).



## his list sets up which plays are which "category" NOTE: There's probably and error somewhere in here.
histories = ["henry_iv_part_1", "henry_iv_part_2", "henry_vi_part_1", "henry_vi_part_2", "henry_vi_part_3", "henry_v", "henry_viii", "king_john", "pericles", "richard_ii", "richard_iii"]
comedies = ["a_midsummer_nights_dream", "alls_well_that_ends_well", "as_you_like_it", "loves_labors_lost", "measure_for_measure", "much_ado_about_nothing", "taming_of_the_shrew", "the_comedy_of_errors", "the_merchant_of_venice", "the_merry_wives_of_windsor", "the_tempest", "the_two_gentlemen_of_verona", "the_winters_tale", "timon_of_athens", "titus_andronicus", "troilus_and_cressida"];
tragedies = ["antony_and_cleopatra", "coriolanus", "cymbeline", "hamlet", "julius_caesar", "king_lear", "macbeth", "othello", "romeo_and_juliet", "twelfth_night"];

##### FLIP TO true TO SEED ALL THE PLAYS
fullPlays = false 


## this sets up the list of plays to parse, if you're trying to change that you're in the right place.
if fullPlays
  #this is the list of all the plays (actually something is wrong with it, but it SHOULD be the list of all plays)
  files =["FolgerDigitalTexts_XML_Complete/MM.xml",
          "FolgerDigitalTexts_XML_Complete/Err.xml",
          "FolgerDigitalTexts_XML_Complete/MV.xml",
          "FolgerDigitalTexts_XML_Complete/Wiv.xml",
          "FolgerDigitalTexts_XML_Complete/PhT.xml",
          "FolgerDigitalTexts_XML_Complete/Tmp.xml",
          "FolgerDigitalTexts_XML_Complete/TGV.xml",
          "FolgerDigitalTexts_XML_Complete/TNK.xml",
          "FolgerDigitalTexts_XML_Complete/WT.xml",
          "FolgerDigitalTexts_XML_Complete/Tim.xml",
          "FolgerDigitalTexts_XML_Complete/Tit.xml",
          "FolgerDigitalTexts_XML_Complete/Tro.xml",
          "FolgerDigitalTexts_XML_Complete/TN.xml",
          "FolgerDigitalTexts_XML_Complete/Ven.xml",
          "FolgerDigitalTexts_XML_Complete/H5.xml",
          "FolgerDigitalTexts_XML_Complete/1H6.xml",
          "FolgerDigitalTexts_XML_Complete/2H6.xml",
          "FolgerDigitalTexts_XML_Complete/3H6.xml",
          "FolgerDigitalTexts_XML_Complete/H8.xml",
          "FolgerDigitalTexts_XML_Complete/JC.xml",
          "FolgerDigitalTexts_XML_Complete/Jn.xml",
          "FolgerDigitalTexts_XML_Complete/Lr.xml",
          "FolgerDigitalTexts_XML_Complete/LLL.xml",
          "FolgerDigitalTexts_XML_Complete/Luc.xml",
          "FolgerDigitalTexts_XML_Complete/Mac.xml",
          "FolgerDigitalTexts_XML_Complete/Ado.xml",
          "FolgerDigitalTexts_XML_Complete/Oth.xml",
          "FolgerDigitalTexts_XML_Complete/Per.xml",
          "FolgerDigitalTexts_XML_Complete/R2.xml",
          "FolgerDigitalTexts_XML_Complete/R3.xml",
          "FolgerDigitalTexts_XML_Complete/Rom.xml",
          "FolgerDigitalTexts_XML_Complete/Son.xml",
          "FolgerDigitalTexts_XML_Complete/Shr.xml",
          "FolgerDigitalTexts_XML_Complete/MND.xml",
          "FolgerDigitalTexts_XML_Complete/AWW.xml",
          "FolgerDigitalTexts_XML_Complete/Ant.xml",
          "FolgerDigitalTexts_XML_Complete/AYL.xml",
          "FolgerDigitalTexts_XML_Complete/Cor.xml",
          "FolgerDigitalTexts_XML_Complete/Cym.xml",
          "FolgerDigitalTexts_XML_Complete/Ham.xml",
          "FolgerDigitalTexts_XML_Complete/1H4.xml",
          "FolgerDigitalTexts_XML_Complete/2H4.xml"]
else

  # Here's what you edit if you want to seed some other set of files. you can expand this list in standard ruby synatx
  files = ["FolgerDigitalTexts_XML_Complete/Err.xml","FolgerDigitalTexts_XML_Complete/MM.xml"]

end





files.each do |file|
  doc = Nokogiri::XML(File.open(file))
  title = doc.css('title').first
  if histories.include?(title.inner_text.downcase.tr(" ", "_"))
    play = Play.create(title: title.inner_text, category: 0) # histories
  elsif comedies.include?(title.inner_text.downcase.tr(" ", "_"))
    play = Play.create(title: title.inner_text, category: 1) # comedies
    puts "play id: " + play.id.to_s
  elsif tragedies.include?(title.inner_text.downcase.tr(" ", "_"))
    play = Play.create(title: title.inner_text, category: 2) # tragedies
  else
    play = Play.create(title: title.inner_text)
  end
  currAct = 1
  currScene = 1
  currIndex = 1
  acts= doc.css('//div1')
  acts.each do |act|
    newact = play.acts.create(number: currAct)
    puts "act" + currAct.to_s
    currAct = currAct + 1
    currScene = 1
    # all the scenes for an act
    scenes = Nokogiri::XML(act.to_s).css('//div2')
    scenes.each do |scene|
      newscene = newact.scenes.create(number: currScene)
      currScene = currScene + 1
      # gets all the lines in the play
      lines = Nokogiri::XML(scene.to_s).css('//sp')
      # added the double-slash on line 101 - removed it later
      stages = Nokogiri::XML(scene.to_s).css('stage').to_a
      stages.each do |stage|
        stageN = stage.attr('xml:id').to_s.gsub("stg-","").to_f
        # numbering them consecutively
        newstage = newscene.lines.create(number: stageN, speaker: "STAGE", isStage: true)
        newstage.words.create(text: stage.inner_text, place: 0)
      end
      lines.each do |line|
        speaker = Nokogiri::XML(line.to_s).css('speaker')
        milestones = Nokogiri::XML(line.to_s).css('milestone')
        spwords = Nokogiri::XML(line.to_s).css('w','c','pc')
        milestones.each do |ms|
          lineNum = ms.attr("n").to_s.split(".")[2]
          wordIDs = ms.attr("corresp").to_s.split(" ")
          wordIDs = wordIDs.map { |w| w.gsub("#","")}
          allthewords = ""
          wordPlace = 0
          # appended currLength to each line
          newline = newscene.lines.create(number: lineNum, speaker: speaker.inner_text, currLength: wordPlace)
          toTextAdd = ""
          toPlaceAdd = 0
          wordIDs.each do |id|
            spwords.each do |word|
              if word.attr('xml:id').to_s == id
                if (word.inner_text == " ")
                  passvvar = ""
                elsif (word.inner_text =~ /[[:alpha:]]/)
                  if (toTextAdd != "")
                    newline.words.create(text: toTextAdd, place: wordPlace)
                  end
                  toTextAdd = word.inner_text
                  toPlaceAdd = wordPlace + 1
                  #allthewords = allthewords + word.inner_text
                  wordPlace = wordPlace + 1
                else
                  toTextAdd = toTextAdd + word.inner_text
                end
              end
              #spword break
            end
            #ID break
          end
          # this last conditional prints the last word everytime
          if (toTextAdd != "")
            newline.words.create(text: toTextAdd, place: wordPlace)
            newline.update(currLength: wordPlace)
          end
        end
        # the line below is the break for a lines
      end
      # scene ends here
    end
    # act ends here
  end
  # file ends here
end

# DO NOT REMOVE THIS LINE
# The admin is the first user when the DB is seeded
User.create(email: "adada@g.hmc.edu", user_name: "Dadaboi", major: "Lit", grad_year: 2005, enrolled: false, admin: true, groups_id:  1, password: "a1somvihar")
Group.create(groupNum: -1, user_id: 1)
