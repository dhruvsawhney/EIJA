class RemovePrevGroupIdBugUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :groups_id
  end
end
