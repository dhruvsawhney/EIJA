module LinesHelper

  # check that the speaker entered is valid
  def isValidSpeaker(id)
    speaker = params[id]

    speaker = speaker.gsub(/\s+/, "").upcase
    l = Line.new
    speakers = l.getAllSpeakers.keys

    speakers.each do |spk|
      if speaker == spk
        return true
      end
    end

    return false
  end
end
