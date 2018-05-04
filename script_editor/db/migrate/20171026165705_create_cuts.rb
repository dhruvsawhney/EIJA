class CreateCuts < ActiveRecord::Migration[5.0]
  def change
    create_table :cuts do |t|
      t.integer :edit_id
      t.integer :word_id
      t.timestamps
    end
  end
end
