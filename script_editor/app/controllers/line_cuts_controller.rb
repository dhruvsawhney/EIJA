class LineCutsController < ApplicationController

  # called from the Cuts controller
  def new
  	LineCut.create(edit_id: params[:editI],line_id: params[:lineI])
  end

  # function NOT called
  def delete
  	LineCut.where(edit_id: params[:editI],line_id: params[:lineId]).first.delete
  end

end

