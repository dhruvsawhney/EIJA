class AddStageDir < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :isStage, :boolean, default: false; 
  end
end
