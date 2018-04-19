class AddCurrLengthToLines < ActiveRecord::Migration[5.0]
  def change
    add_column :lines, :currLength, :integer
  end
end
