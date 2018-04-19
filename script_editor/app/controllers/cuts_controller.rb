require 'json'


class CutsController < ApplicationController

  # add logic similar to the edits_ctrl#show to check if an edit object is made, else, make a new one

  # ensure that the where clause calls [0] index value to get the object from the array
  def new

    # update the edit here
    # groups_id is the row NOT THE GROUP NUM

    # from the cookie we will get the GROUP NUMBER
    # for the current_user we have the userID
    # the combination of GroupNumber and UserId will give the "groups_id" row from the Groups table

    group_number = cookies[:group_number]
    group_number = group_number.to_i

    # puts "THE GROUP NUMBER IS: #{group_number}"

    group_id = Group.find_by_sql ["select * from Groups where user_id = ? and groupNum = ?",current_user.id,group_number]

    # added the correct groupID
    edit_object = Edit.where({user_id: current_user.id , play_id: params[:meta][:playID], groups_id: group_id})
    # edit_object = edit_object[0]

    pID = params[:meta][:playID].to_i

    # edit_object is an array
    if edit_object.length == 0
      # EditsController.makeEdit(current_user.id,pID,group_id)
      # puts "HERE !!"
      Edit.create({:user_id => current_user.id, :play_id => pID, :groups_id => group_id})
    end


    edit_object = Edit.where({user_id: current_user.id , play_id: pID , groups_id: group_id})

    # puts "THE CLASS IS: #{edit_object}"
    # puts "The CLASS IS NULL: #{edit_object.length == 0}"

    # edit_object = edit_object[0]

    # DO NOT TOUCH THIS LINE
    edit_id = edit_object[0].id

    # puts "THE EDIT ID IS: #{edit_id}"
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