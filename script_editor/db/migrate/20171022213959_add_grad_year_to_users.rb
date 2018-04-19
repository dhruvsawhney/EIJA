class AddGradYearToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :grad_year, :int
  end
end
