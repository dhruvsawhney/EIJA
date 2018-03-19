class LineCutsController < ApplicationController
	# do not have a lineI param
	# call 'new' method from Cut Controller 'new' action
  def new
  	LineCut.create(edit_id: params[:editI],line_id: params[:lineI])
  end

  # do not use this
  def delete
  	LineCut.where(edit_id: params[:editI],line_id: params[:lineId]).first.delete

  end

end

