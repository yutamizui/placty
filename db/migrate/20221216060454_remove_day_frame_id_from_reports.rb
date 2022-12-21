class RemoveDayFrameIdFromReports < ActiveRecord::Migration[6.1]
  def change
    remove_column :reports, :day_frame_id, :integer
  end
end
