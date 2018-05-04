class ChangeGroupNameDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:groups, :name, "")
  end
end
