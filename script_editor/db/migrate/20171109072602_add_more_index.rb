class AddMoreIndex < ActiveRecord::Migration[5.0]
  def change
    add_index(:acts, :play_id)
    add_index(:lines, :scene_id)
    add_index(:scenes, :act_id)
  end
end
