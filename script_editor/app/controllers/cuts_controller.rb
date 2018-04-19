require 'json'


class CutsController < ApplicationController

  def new

    # update the edit here
    edit_object = Edit.where({user_id: current_user.id , play_id: params[:meta][:playID], groups_id: current_user.groups_id}).update(updated_at: Time.now)
    edit_id = edit_object[0].id
    cutAndUncut(params[:payload],params[:meta][:cutOrUncut],edit_id)

  end

  # payload: the list of wordIds to cut/uncut
  # binOpt: true means to cut the word and false means to uncut
  # editId: the editId for the Cut being made :: hardcoded to 1 for now
  #         earlier params[id] was used that was constant for a given user

  def cutAndUncut(payload, binOpt, editId)

    if payload != nil && payload.length != 0
      for wordID in payload do

        if binOpt == "true"

          @cut = Cut.create(edit_id: editId,word_id: wordID)

          # get the word -> the line.id of the word -> update the length of the line with the update method
          # this is word_id in the data-base
          @word = @cut.word
          @line = @word.line

          if @line.currLength > 0
            editLength = @line.currLength - 1
            @line.update(currLength: editLength)

            # add editId and lineId for LineCut relationship
            if editLength == 0
              # the user has an id
              # use that id to get the row in the edits table
              LineCut.create(edit_id: editId, line_id: @line.id)
            end
          end
        else
          # get the cut data-entry with the appropriate entries
          #  delete it from the DB
          @cut = Cut.where(edit_id: editId,word_id: wordID).first.delete

          # increment the line-length
          @word = @cut.word
          @line = @word.line

          # un-cut the line from LineCut table
          # if currLength is 0
          if @line.currLength == 0
            @line.update(currLength: 1)
            LineCut.where(edit_id: editId, line_id: @line.id).first.delete
          else
            editLength = @line.currLength + 1
            @line.update(currLength: editLength)
          end
        end
      end
    end
  end

end
