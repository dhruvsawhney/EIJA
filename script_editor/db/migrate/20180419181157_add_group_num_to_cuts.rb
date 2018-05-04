class AddGroupNumToCuts < ActiveRecord::Migration[5.0]
  def change
    add_column :cuts, :groupNum, :integer
    change_column_default :cuts, :groupNum, -1
  end
end
