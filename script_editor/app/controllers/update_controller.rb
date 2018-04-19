class UpdateController < ApplicationController
	require 'open-uri'
	respond_to :html, :json

	def new
	end

	def show
		edit_id = params[:meta][:editID]
		cuts = Cut.find_by_sql(["Select word_id from Cuts where edit_id = ? and created_at > ?",edit_id, Time.now-5.minutes]).map{|x| x.word_id}
		uncuts = Uncut.find_by_sql(["Select word_id from Uncuts where edit_id = ? and created_at > ?",edit_id, Time.now-5.minutes]).map{|x| x.word_id}
		# puts "#{cuts}"
		# puts "#{uncuts.map{|x| x.word_id}}"
		# puts "#{cuts.map{|x| x.word_id} }"
		respond_to do |format|
    		cuts = 	{
			        "meta" => {
			            "editID" => params[:meta][:editID] #Xans gon take u Xans gonna betray u
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


