class CutsController < ApplicationController

  def new
  	#  are combining new (GET) and create (POST) actions
  	@cut = Cut.create(edit_id: params[:editI],word_id: params[:wordI])

  	# get the word -> the line.id of the word -> update the length of the line with the update method
  	# this is word_id in the data-base
  	@word = @cut.word
  	@line = @word.line

		if @line.currLength > 0
			editLength = @line.currLength - 1
			@line.update(currLength: editLength)

			# add editId and lineId for LineCut relationship
			if editLength == 0
				LineCut.create(edit_id: params[:editI], line_id: @line.id)
			end
		end

  end

  def delete
  	# get the cut data-entry with the appropriate entries
  	#  delete it from the DB
  	@cut = Cut.where(edit_id: params[:editI],word_id: params[:wordI]).first.delete

		# increment the line-length
		@word = @cut.word
		@line = @word.line

		# un-cut the line from LineCut table
		# if currLength is 0
		if @line.currLength == 0
			@line.update(currLength: 1)
			LineCut.where(edit_id: params[:editI], line_id: @line.id).first.delete
		else
			editLength = @line.currLength + 1
			@line.update(currLength: editLength)
		end
	  end
end
