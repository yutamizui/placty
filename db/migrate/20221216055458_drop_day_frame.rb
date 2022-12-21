class DropDayFrame < ActiveRecord::Migration[6.1]
  def change
    drop_table :day_frames
  end
end
