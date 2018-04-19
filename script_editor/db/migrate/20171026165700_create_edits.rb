class CreateEdits < ActiveRecord::Migration[5.0]
  def change
    create_table :edits do |t|
      t.integer :user_id
      t.integer :play_id

      t.timestamps
    end
  end
end
