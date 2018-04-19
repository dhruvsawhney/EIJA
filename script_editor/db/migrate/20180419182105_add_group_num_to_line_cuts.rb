class AddGroupNumToLineCuts < ActiveRecord::Migration[5.0]
  def change
    add_column :line_cuts, :groupNum, :integer
    change_column_default :line_cuts, :groupNum, -1
  end
end
