class AddGroupNumToUncuts < ActiveRecord::Migration[5.0]
  def change
    add_column :uncuts, :groupNum, :integer
    change_column_default :uncuts, :groupNum, -1
  end
end
