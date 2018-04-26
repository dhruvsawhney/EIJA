require 'json'


class CutsController < ApplicationController


  # the function that the edits view interacts with to make cuts
  def new

    # from the cookie we will get the GROUP NUMBER
    # for the current_user we have the userID
    # the combination of GroupNumber and UserId will give the "groups_id" row from the Groups table

    # sanitize input from strings to integers
    group_number = cookies[:group_num]
    group_number = group_number.to_i
    pID = params[:meta][:playID].to_i

    group_object = Group.find_by_sql ["select * from Groups where user_id = ? and groupNum = ?", current_user.id, group_number]
    group_object = group_object[0]
    group_id = group_object.id

    # added the correct groupID
    edit_object = Edit.where({user_id: current_user.id, play_id: pID, groups_id: group_id})

    # edit_object is an array
    if edit_object.length == 0
      Edit.create({:user_id => current_user.id, :play_id => pID, :groups_id => group_id})
    end

    edit_object = Edit.where({user_id: current_user.id, play_id: pID, groups_id: group_id})
    # get the Edit Object
    edit_object = edit_object[0]
    edit_id = edit_object.id

    cutAndUncut(params[:payload], params[:meta][:cutOrUncut], edit_id, group_number)
  end

  # main function for making edits
  # interacts with the databases: Cuts, Uncuts, LineCut
  def cutAndUncut(payload, binOpt, editId, group_number)

    if payload != nil && payload.length != 0
      for wordID in payload do

        if binOpt == "true"
          # remove from the uncut table
          @uncut = Uncut.where(word_id: wordID, groupNum: group_number)

          if @uncut.length != 0
            Uncut.where(word_id: wordID, groupNum: group_number).first.delete
          end

          @cut = Cut.create(edit_id: editId, word_id: wordID, groupNum: group_number)

          # get the word -> the line.id of the word
          # -> update the length of the line with the update method
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
              LineCut.create(edit_id: editId, line_id: @line.id, groupNum: group_number)
            end
          end
        else

          Uncut.create(edit_id: editId, word_id: wordID, groupNum: group_number)
          @cut = Cut.where(word_id: wordID, groupNum: group_number)

          # this is a bug
          # for some reason the wordID and groupNumber (more likely this) is not rendered
          if @cut.length == 0
            next
          end
          @cut = Cut.where(word_id: wordID, groupNum: group_number).first.delete
          # increment the line-length
          @word = @cut.word
          @line = @word.line

          # un-cut the line from LineCut table
          if @line.currLength == 0
            @line.update(currLength: 1)
            LineCut.where(line_id: @line.id, groupNum: group_number).first.delete
          else
            editLength = @line.currLength + 1
            @line.update(currLength: editLength)
          end
        end
      end
    end
  end


end