class AddDayFrameIdToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :day_frame_id, :integer
  end
end
