class CreateLines < ActiveRecord::Migration[5.0]
  def change
    create_table :lines do |t|
      t.integer :number
      t.integer :scene_id
      t.string :speaker

      t.timestamps
    end
  end
end
