class AddEnrolledToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :enrolled, :boolean
  end
end
