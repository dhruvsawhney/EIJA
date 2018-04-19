class AddUncutsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :uncuts do |t|
  		t.timestamps
  	end
  end
end
