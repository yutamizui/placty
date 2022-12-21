class RemoveDayFrameIdFromItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :day_frame_id, :integer
  end
end
