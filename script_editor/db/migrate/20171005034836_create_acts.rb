class CreateActs < ActiveRecord::Migration[5.0]
  def change
    create_table :acts do |t|
      t.integer :number
      t.integer :play_id

      t.timestamps
    end
  end
end
