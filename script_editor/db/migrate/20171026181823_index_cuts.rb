class IndexCuts < ActiveRecord::Migration[5.0]
  def change
    add_index(:cuts, :word_id)
    add_index(:cuts, :edit_id)
  end
end
