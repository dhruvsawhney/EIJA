class Change < ActiveRecord::Migration[5.0]
  def change
	rename_column :uncuts, :edits_id, :edit_id
  end
end
