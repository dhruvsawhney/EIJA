class MakeGroupsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.integer :groupNum
      t.timestamps
    end
  end
end
