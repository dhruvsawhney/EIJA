# the main controller to make collaboration happen
class UpdateController < ApplicationController
  require 'open-uri'
  respond_to :html, :json

  def new
  end

  def show
    group_number = params[:meta][:groupNum]
    group_number = group_number.to_i
    if params[:meta][:timePeriodFlag] == 'true'
      flag = true
    elsif params[:meta][:timePeriodFlag] == 'false'
      flag = false
    end

    respond_to do |format|
      cuts = {
          "meta" => {
              "playID" => params[:meta][:playID],
              "groupNum" => params[:meta][:groupNum]
          },
          "payload" => {"cut" => getCutLists(group_number, params[:meta][:playID].to_i, flag),
                        "uncut" => getUnCutLists(group_number, params[:meta][:playID].to_i, flag)}
      }
      format.json {render :json => cuts}
    end
  end


  def userNames
    respond_to do |format|
      out = {
          "meta" => {
              "editID" => params[:meta][:editID] #Xans gon take u Xans gonna betray u
          }
      }
      format.json {render :json => out}
    end
  end


  # return the list of recent cut wordIDs
  # flag: True, gets the cuts in the previous 5 minutes
  # 			False, gets all the edits for the groupNumber
  def getCutLists(group_number, p_id, flag)
    cut_word_lst = []

    cutsLst = Cut.where(:groupNum => group_number)

    cutsLst.each do |cut|
      edit_object = Edit.where(:play_id => p_id).first

      if edit_object.play_id == p_id
        if flag
          # query for cuts to enter condition
          # want cuts from 5 minutes ago
          if cut.created_at > Time.now - 5.minutes
            cut_word_lst.append(cut.word_id)
          end
        else
          cut_word_lst.append(cut.word_id)
        end
      end
    end

    return cut_word_lst
  end

  # return the list of recent cut wordIDs
  # flag: True, gets the uncuts in the previous 5 minutes
  # 			False, gets all the edits for the groupNumber
  def getUnCutLists(group_number, p_id, flag)
    uncut_word_lst = []

    uncutsLst = Uncut.where(:groupNum => group_number)

    uncutsLst.each do |uncut|
      edit_object = Edit.where(:play_id => p_id).first

      if edit_object.play_id == p_id
        if flag
          if uncut.created_at > Time.now - 5.minutes
            uncut_word_lst.append(uncut.word_id)
          end
        else
          uncut_word_lst.append(uncut.word_id)
        end
      end
    end
    return uncut_word_lst
  end

end
