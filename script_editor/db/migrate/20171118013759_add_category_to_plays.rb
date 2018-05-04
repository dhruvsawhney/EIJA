class AddCategoryToPlays < ActiveRecord::Migration[5.0]
  def change
    add_column :plays, :category, :int
  end
end
