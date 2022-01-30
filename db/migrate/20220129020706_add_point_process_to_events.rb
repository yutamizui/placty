class AddPointProcessToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :point_process, :boolean, default: false
  end
end
