class CreateScenes < ActiveRecord::Migration[5.0]
  def change
    create_table :scenes do |t|
      t.integer :number
      t.integer :act_id

      t.timestamps
    end
  end
end
