class AddGroupsRefToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :groups, foreign_key: true
  end
end
