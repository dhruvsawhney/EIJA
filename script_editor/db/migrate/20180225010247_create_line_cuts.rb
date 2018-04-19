class CreateLineCuts < ActiveRecord::Migration[5.0]
  def change
    create_table :line_cuts do |t|
      t.integer :edit_id, index: true
      t.integer :line_id, index: true     
      t.timestamps
    end
  end
end
