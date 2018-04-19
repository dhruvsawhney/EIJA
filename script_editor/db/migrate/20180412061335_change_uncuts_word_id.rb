class ChangeUncutsWordId < ActiveRecord::Migration[5.0]
  def change
  	rename_column :uncuts, :words_id, :word_id
  end
end
