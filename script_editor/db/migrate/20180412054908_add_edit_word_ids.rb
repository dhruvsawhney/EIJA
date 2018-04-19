class AddEditWordIds < ActiveRecord::Migration[5.0]
  def change
  	add_reference :uncuts, :edits, foreign_key: true
  	add_reference :uncuts, :words, foreign_key: true
  end
end
