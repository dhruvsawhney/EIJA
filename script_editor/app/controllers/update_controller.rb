class UpdateController < ApplicationController
	require 'open-uri'
	respond_to :html, :json

	def new
	end

	def show
		group_number = params[:meta][:groupNum]
		group_number = group_number.to_i
    if params[:meta][:timePeriodFlag] == 'true'
      flag =true
    elsif params[:meta][:timePeriodFlag] == 'false'
      flag = false
    end
		#group_id = Group.find_by_sql ["select * from Groups where user_id = ? and groupNum = ?",current_user.id,group_number]
    #group_id = Group.where({user_id: current_user.id , groupNum: group_number})[0].id
		# puts " play ID: #{params[:meta][:playID].to_i} GroupID: #{group_number} query result: #{Edit.where({user_id: current_user.id , play_id: params[:meta][:playID].to_i, groups_id:group_number})}"
		# # edit_id= Edit.where({user_id: current_user.id , play_id: params[:meta][:playID].to_i, groups_id:group_number})[0].id
		# cuts = Cut.find_by_sql(["Select word_id from Cuts where groupNum = ? play_id = ? and created_at > ?",Integer(cookies[:group_num]), Integer(cookies[:play_id]),Time.now-5.minutes]).map{|x| x.word_id}
		# uncuts = Uncut.find_by_sql(["Select word_id from Uncuts where roupNum = ? play_id = ?and created_at > ?",Integer(cookies[:group_num]), Integer(cookies[:play_id]), Time.now-5.minutes]).map{|x| x.word_id}
		# puts "#{cuts}"
		# puts "#{uncuts.map{|x| x.word_id}}"
		# puts "#{cuts.map{|x| x.word_id} }"
		respond_to do |format|
    		cuts = 	{
			        "meta" => {
			            "playID" => params[:meta][:playID], #Xans gon take u Xans gonna betray u
									"groupNum" => params[:meta][:groupNum]
			        },
			        "payload" => { "cut" => getCutLists(group_number,params[:meta][:playID].to_i, flag),
								             "uncut" => getUnCutLists(group_number,params[:meta][:playID].to_i, flag)}
				    }
    		format.json  { render :json => cuts} 
    	end
  	end

<<<<<<< HEAD
  	def makeGroups
  		
  		respond_to do |format|
    		groups = 	{
			        "meta" => {
			            "usersID" => params[:meta][:usersID],
						"name" => params[:meta][:name]
			        }
			    }
    		format.json  { render :json => groups} 
  	end

  	def makeAdmin
  		respond_to do |format|
    		admins = 	{
			        "meta" => {
			            "usersID" => params[:meta][:usersID]
			        }
			    }
    		format.json  { render :json => admins} 
  	end

	def userNames
		#do things here
		#
		respond_to do |format|
			out = 	{
					"meta" => {
							"editID" => params[:meta][:editID] #Xans gon take u Xans gonna betray u
					}
			}
			format.json  { render :json => out}
			end
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
					if cut.created_at > Time.now-5.minutes
						cut_word_lst.append(cut.word_id)
					end
				else
					cut_word_lst.append(cut.word_id)
				end
			end
		end

		return cut_word_lst
	end


end
