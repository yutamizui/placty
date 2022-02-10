class RemovePointProcessFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :point_process, :boolean
  end
end
