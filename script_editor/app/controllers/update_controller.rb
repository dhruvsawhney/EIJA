class UpdateController < ApplicationController
	require 'open-uri'
	respond_to :html, :json

	def new
	end

	def show
		group_number = params[:meta][:groupNum]
		group_number = group_number.to_i
		#group_id = Group.find_by_sql ["select * from Groups where user_id = ? and groupNum = ?",current_user.id,group_number]
    #group_id = Group.where({user_id: current_user.id , groupNum: group_number})[0].id
		puts " play ID: #{params[:meta][:playID].to_i} GroupID: #{group_number} query result: #{Edit.where({user_id: current_user.id , play_id: params[:meta][:playID].to_i, groups_id:group_number})}"
		edit_id= Edit.where({user_id: current_user.id , play_id: params[:meta][:playID].to_i, groups_id:group_number})[0].id
		cuts = Cut.find_by_sql(["Select word_id from Cuts where groupNum = ? play_id = ? and created_at > ?",Integer(cookies[:group_num]), Integer(cookies[:play_id]),Time.now-5.minutes]).map{|x| x.word_id}
		uncuts = Uncut.find_by_sql(["Select word_id from Uncuts where roupNum = ? play_id = ?and created_at > ?",Integer(cookies[:group_num]), Integer(cookies[:play_id]), Time.now-5.minutes]).map{|x| x.word_id}
		# puts "#{cuts}"
		# puts "#{uncuts.map{|x| x.word_id}}"
		# puts "#{cuts.map{|x| x.word_id} }"
		respond_to do |format|
    		cuts = 	{
			        "meta" => {
			            "playID" => params[:meta][:playID], #Xans gon take u Xans gonna betray u
									"groupNum" => params[:meta][:groupNum]
			        },
			        "payload" => { "cut" => cuts,
								  "uncut" => uncuts}
				    }
    		format.json  { render :json => cuts} 
    	end
  	end

  	def update_cuts
  	end
end


