class AddDayFrameIdToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :day_frame_id, :integer
  end
end
