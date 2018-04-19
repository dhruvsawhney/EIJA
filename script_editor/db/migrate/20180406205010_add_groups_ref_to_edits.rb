class AddGroupsRefToEdits < ActiveRecord::Migration[5.0]
  def change
    add_reference :edits, :groups, foreign_key: true
  end
end
